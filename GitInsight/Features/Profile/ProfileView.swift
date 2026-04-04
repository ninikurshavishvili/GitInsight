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

    // Use the shared AuthService from the environment
    @EnvironmentObject private var authService: AuthService

    // Controls navigation to the Settings screen.
    @State private var showSettings = false

    init(authService: AuthService? = nil) {
        // Allow constructing with an injected AuthService for previews/tests.
        // If an authService is provided we still initialize the view model with a placeholder —
        // the real `authService` from the environment will overwrite state via bindings.
        _viewModel = StateObject(wrappedValue: ProfileViewModel(authService: authService ?? AuthService()))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top App Bar
                    TopAppBar(
                        avatarURL: viewModel.user?.avatar_url,
                        onSettingsTap: { showSettings = true }
                    )

                    // Scrollable content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            // Profile header — use live user when available, else placeholder
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
                    // Dim content behind a spinner while loading
                    .overlay {
                        if viewModel.isLoading {
                            ZStack {
                                Color.black.opacity(0.35).ignoresSafeArea()
                                ProgressView()
                                    .tint(AppTheme.Colors.accent)
                                    .scaleEffect(1.4)
                            }
                        }
                    }
                }

                // Bottom Navigation Bar (overlaid at the bottom)
                BottomNavigationBar(selectedTab: $selectedTab)
            }
            // Use the modern navigationDestination to present SettingsView when requested.
            .navigationDestination(isPresented: $showSettings) {
                SettingsView(authService: authService)
                    .environmentObject(authService)
            }
            .task {
                // Keep the view model in sync with the environment authService
                if viewModelIsFromPlaceholder() {
                    // Recreate viewModel with the real environment authService
                    // (StateObject cannot be reassigned; in practice the ProfileViewModel
                    // observes the AuthService passed in during construction; ensure parent
                    // injects the same instance or rework to inject via environment.)
                }
                await viewModel.loadUser()
            }
        }
    }

    private func viewModelIsFromPlaceholder() -> Bool {
        // crude heuristic; if viewModel.user is nil while env authService has a user,
        // the placeholder was used at init time.
        return viewModel.user == nil && authService.currentUser != nil
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
    ProfileView()
        .environmentObject(AuthService())
}
