//
//  LoginViewModel.swift
//  GitInsight
//

import Foundation
import Combine

/// Drives the login screen, forwarding auth state from `AuthService` and
/// exposing a single `signIn()` action.
@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Private

    private let authService: AuthService
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    init(authService: AuthService) {
        self.authService = authService

        authService.$isLoading
            .assign(to: &$isLoading)

        authService.$errorMessage
            .assign(to: &$errorMessage)
    }

    // MARK: - Actions

    /// Initiates the GitHub OAuth flow.
    func signIn() {
        authService.signInWithGitHub()
    }
}
