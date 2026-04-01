//
//  ProfileView.swift
//  GitInsight
//

import SwiftUI

/// Full-screen profile experience: top bar, scrollable stats, heatmap,
/// language breakdown, architecture pulse, and bottom navigation.
struct ProfileView: View {

    @StateObject private var viewModel: ProfileViewModel
    @State private var selectedTab: BottomNavigationBar.Tab = .profile

    init(authService: AuthService) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(authService: authService))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top App Bar
                TopAppBar(
                    avatarURL: viewModel.user?.avatar_url,
                    onSettingsTap: {}
                )

                // Scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Profile header — use live user when available, else mock
                        ProfileHeaderView(user: viewModel.user ?? placeholderUser)

                        // Cards group
                        ContributionHeatmapView(data: viewModel.heatmapData)
                            .padding(.horizontal, 16)

                        QuickStatsView(
                            totalCommits: viewModel.repositoryStats.totalCommits,
                            totalRepos:   viewModel.repositoryStats.totalRepos
                        )
                        .padding(.horizontal, 16)

                        LanguagesCardView(stats: viewModel.languageStats)
                            .padding(.horizontal, 16)

                        ArchitecturePulseView(
                            score:           viewModel.repositoryStats.architectureScore,
                            grade:           viewModel.repositoryStats.architectureGrade,
                            sparklinePoints: viewModel.repositoryStats.sparklinePoints
                        )
                        .padding(.horizontal, 16)

                        // Extra padding so last card clears the tab bar
                        Color.clear.frame(height: 88)
                    }
                }
            }

            // Bottom Navigation Bar (overlaid at the bottom)
            BottomNavigationBar(selectedTab: $selectedTab)
        }
        .task {
            await viewModel.loadUser()
        }
    }

    // MARK: - Placeholder

    /// Placeholder user shown before sign-in or while loading.
    private var placeholderUser: GitHubUser {
        GitHubUser(
            id: 0,
            login: "gitinsight_user",
            name: "GitInsight User",
            avatar_url: nil,
            bio: "Building great software, one commit at a time.",
            public_repos: 0,
            followers: 0,
            following: 0
        )
    }
}

// MARK: - Preview

#Preview {
    ProfileView(authService: AuthService())
}
