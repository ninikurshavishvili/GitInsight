//
//  ProfileViewModel.swift
//  GitInsight
//

import Foundation
import Combine

/// Drives the profile screen, exposing user data and a sign-out action.
@MainActor
final class ProfileViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var user: GitHubUser?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Private

    private let authService: AuthService
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init

    init(authService: AuthService) {
        self.authService = authService

        authService.$currentUser
            .assign(to: &$user)

        authService.$isLoading
            .assign(to: &$isLoading)

        authService.$errorMessage
            .assign(to: &$errorMessage)
    }

    // MARK: - Actions

    /// Loads the authenticated user profile if not already loaded.
    func loadUser() async {
        await authService.loadUserIfTokenExists()
    }

    /// Signs the user out and clears all stored credentials.
    func signOut() {
        authService.signOut()
    }
}
