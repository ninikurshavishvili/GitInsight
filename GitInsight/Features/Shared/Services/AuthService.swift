//
//  AuthService.swift
//  GitInsight
//

import Foundation
import Combine
import AuthenticationServices
import UIKit

/// Manages the full GitHub OAuth lifecycle: browser login, code exchange,
/// Keychain token storage, and profile fetching.
///
/// **One-time configuration required:**
/// 1. Replace `clientId` and `clientSecret` with your GitHub OAuth App credentials
///    (Settings → Developer settings → OAuth Apps → New OAuth App).
/// 2. In Xcode: select the GitInsight target → **Info** → **URL Types** → tap **+**,
///    then set **URL Schemes** to `gitinsight` (must match `redirectScheme` below).
@MainActor
final class AuthService: NSObject, ObservableObject {

    // MARK: - Published state

    @Published private(set) var accessToken: String?
    @Published private(set) var currentUser: GitHubUser?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Configuration

    /// Your GitHub OAuth App Client ID.
    private let clientId = "YOUR_CLIENT_ID"

    /// Your GitHub OAuth App Client Secret.
    /// ⚠️ For production apps, move the token exchange to a secure backend service
    /// so the secret is never embedded in the binary.
    private let clientSecret = "YOUR_CLIENT_SECRET"

    /// Must match the URL scheme registered in Xcode → Target → Info → URL Types.
    private let redirectScheme = "gitinsight"
    private let redirectURI   = "gitinsight://oauth-callback"
    private let scope         = "read:user"

    private let tokenKeychainAccount = "github_access_token"
    private var webAuthSession: ASWebAuthenticationSession?

    // MARK: - Init

    override init() {
        super.init()
        accessToken = try? KeychainService.read(account: tokenKeychainAccount)
    }

    // MARK: - Public API

    /// Opens the GitHub OAuth authorization page and, on success, exchanges the
    /// code for a token, stores it in the Keychain, and loads the user profile.
    func signInWithGitHub() {
        errorMessage = nil
        let state = UUID().uuidString

        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id",    value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope",        value: scope),
            URLQueryItem(name: "state",        value: state)
        ]

        guard let authURL = components.url else {
            errorMessage = "Failed to build GitHub authorization URL."
            return
        }

        isLoading = true

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

                guard
                    let callbackURL,
                    let queryItems = URLComponents(
                        url: callbackURL,
                        resolvingAgainstBaseURL: false
                    )?.queryItems,
                    let code          = queryItems.first(where: { $0.name == "code" })?.value,
                    let returnedState = queryItems.first(where: { $0.name == "state" })?.value
                else {
                    self.errorMessage = "Invalid callback URL."
                    return
                }

                guard returnedState == state else {
                    self.errorMessage = "OAuth state mismatch — possible CSRF attack."
                    return
                }

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

        webAuthSession?.presentationContextProvider = self
        webAuthSession?.prefersEphemeralWebBrowserSession = false
        webAuthSession?.start()
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

    // MARK: - Private

    private func exchangeCodeForToken(code: String) async throws -> String {
        var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var bodyComponents = URLComponents()
        bodyComponents.queryItems = [
            URLQueryItem(name: "client_id",     value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "code",          value: code),
            URLQueryItem(name: "redirect_uri",  value: redirectURI)
        ]
        request.httpBody = bodyComponents.percentEncodedQuery?.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        struct TokenResponse: Decodable {
            let access_token: String
        }

        return try JSONDecoder().decode(TokenResponse.self, from: data).access_token
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

extension AuthService: ASWebAuthenticationPresentationContextProviding {
    /// Called by `ASWebAuthenticationSession` on the main thread to obtain a
    /// presentation window.  `nonisolated` + `MainActor.assumeIsolated` is safe
    /// here because the system always calls this method on the main thread.
    nonisolated func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        MainActor.assumeIsolated {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.keyWindow ?? ASPresentationAnchor()
        }
    }
}
