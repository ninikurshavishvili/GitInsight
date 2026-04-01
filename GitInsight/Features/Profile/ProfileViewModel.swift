//
//  ProfileViewModel.swift
//  GitInsight
//

import Foundation
import Combine
import SwiftUI

/// Drives the profile screen, exposing user data, stats, and a sign-out action.
@MainActor
final class ProfileViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var user: GitHubUser?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // MARK: - Mock profile data (used until real API is wired up)

    @Published private(set) var repositoryStats = RepositoryStats(
        totalCommits: 2_847,
        totalRepos: 42,
        architectureScore: 94,
        architectureGrade: "A",
        sparklinePoints: [0.3, 0.5, 0.4, 0.7, 0.6, 0.9, 0.8, 1.0, 0.7, 0.85, 0.6, 0.75]
    )

    @Published private(set) var languageStats: [LanguageStat] = [
        LanguageStat(name: "JavaScript", percentage: 42, color: Color(hex: 0xF7DF1E)),
        LanguageStat(name: "TypeScript", percentage: 28, color: Color(hex: 0x3178C6)),
        LanguageStat(name: "Rust",       percentage: 18, color: Color(hex: 0xDEA584)),
        LanguageStat(name: "PHP",        percentage: 12, color: Color(hex: 0x777BB4))
    ]

    @Published private(set) var heatmapData: [[Int]] = {
        var grid: [[Int]] = []
        for _ in 0..<52 {
            var week: [Int] = []
            for _ in 0..<7 {
                week.append(Int.random(in: 0...4))
            }
            grid.append(week)
        }
        return grid
    }()

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
