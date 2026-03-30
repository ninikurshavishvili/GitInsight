import Foundation
import Combine
import AuthenticationServices
import UIKit

@MainActor
final class AuthService: NSObject, ObservableObject {

    // MARK: - Published state
    @Published private(set) var accessToken: String?
    @Published private(set) var currentUser: GitHubUser?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    // MARK: - OAuth configuration
    private let clientId = GitHubAuthConfig.clientID

    /// ⚠️ For production: do NOT embed secrets in the app.
    /// Keep this only for local debugging / prototype.
    private let clientSecret = "fakeclientSecretedeba272b6af0d4eef6bd"

    private let redirectScheme = GitHubAuthConfig.callbackURLScheme   // "gitinsight"
    private let redirectURI = GitHubAuthConfig.redirectURI            // "gitinsight://oauth-callback"
    private let scope = GitHubAuthConfig.scope                        // "read:user"

    private let tokenKeychainAccount = "github_access_token"
    private var webAuthSession: ASWebAuthenticationSession?

    override init() {
        super.init()
        accessToken = try? KeychainService.read(account: tokenKeychainAccount)
    }

    // MARK: - Public API (DO NOT remove — UI depends on these names)

    func signInWithGitHub() {
        errorMessage = nil
        let state = UUID().uuidString

        guard let authURL = buildAuthorizationURL(state: state) else {
            errorMessage = "Failed to build GitHub authorization URL."
            return
        }

        isLoading = true
        startWebAuthSession(authURL: authURL, expectedState: state)
    }

    /// Clears the stored token and user, returning to the unauthenticated state.
    func signOut() {
        KeychainService.delete(account: tokenKeychainAccount)
        accessToken  = nil
        currentUser  = nil
        errorMessage = nil
    }

    /// Silently loads the user profile using a persisted token (called on app launch).
    /// Calls `signOut()` if the token is invalid.
    func loadUserIfTokenExists() async {
        guard let token = accessToken, currentUser == nil else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            currentUser = try await GitHubAPIService.fetchAuthenticatedUser(accessToken: token)
        } catch {
            signOut()
        }
    }

    // MARK: - URL building

    private func buildAuthorizationURL(state: String) -> URL? {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "state", value: state)
        ]
        return components?.url
    }

    // MARK: - ASWebAuthenticationSession

    private func startWebAuthSession(authURL: URL, expectedState: String) {
        webAuthSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: redirectScheme
        ) { [weak self] callbackURL, error in
            guard let self else { return }
            Task { @MainActor in
                self.isLoading = false

                if let error {
                    let cancelled = (error as? ASWebAuthenticationSessionError)?.code == .canceledLogin
                    if !cancelled {
                        self.errorMessage = error.localizedDescription
                    }
                    return
                }

                self.handleOAuthCallback(callbackURL, expectedState: expectedState)
            }
        }

        webAuthSession?.presentationContextProvider = self
        webAuthSession?.prefersEphemeralWebBrowserSession = false
        webAuthSession?.start()
    }

    private func handleOAuthCallback(_ callbackURL: URL?, expectedState: String) {
        guard
            let callbackURL,
            let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
        else {
            errorMessage = "Invalid callback URL."
            return
        }

        let code = queryItems.first(where: { $0.name == "code" })?.value
        let returnedState = queryItems.first(where: { $0.name == "state" })?.value

        guard let code, !code.isEmpty else {
            errorMessage = "Missing authorization code in callback."
            return
        }

        guard returnedState == expectedState else {
            errorMessage = "OAuth state mismatch — possible CSRF attack."
            return
        }

        // Debug log requested
        print("GitHub OAuth authorization code:", code)

        Task { @MainActor in
            do {
                self.isLoading = true
                let token = try await self.exchangeCodeForToken(code: code)
                try KeychainService.save(token, account: self.tokenKeychainAccount)
                self.accessToken = token
                self.currentUser = try await GitHubAPIService.fetchAuthenticatedUser(accessToken: token)
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }

    // MARK: - Token exchange

    private func exchangeCodeForToken(code: String) async throws -> String {
        var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectURI)
        ]
        request.httpBody = bodyComponents.percentEncodedQuery?.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        struct TokenResponse: Decodable { let access_token: String }
        return try JSONDecoder().decode(TokenResponse.self, from: data).access_token
    }
}

extension AuthService: ASWebAuthenticationPresentationContextProviding {
    nonisolated func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        MainActor.assumeIsolated {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.keyWindow ?? ASPresentationAnchor()
        }
    }
}
