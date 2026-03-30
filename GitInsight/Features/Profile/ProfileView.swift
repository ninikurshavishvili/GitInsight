//
//  ProfileView.swift
//  GitInsight
//

import SwiftUI

/// Displays the authenticated user's avatar, username, full name,
/// public repository count, and follower count, with a sign-out button.
struct ProfileView: View {

    @StateObject private var viewModel: ProfileViewModel

    init(authService: AuthService) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(authService: authService))
    }

    var body: some View {
        NavigationStack {
            Group {
                if let user = viewModel.user {
                    userContent(user)
                } else if viewModel.isLoading {
                    ProgressView("Loading profile…")
                } else {
                    Text(viewModel.errorMessage ?? "Unable to load profile.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profile")
            .task {
                await viewModel.loadUser()
            }
        }
    }

    // MARK: - Private views

    @ViewBuilder
    private func userContent(_ user: GitHubUser) -> some View {
        VStack(spacing: 20) {
            AsyncImage(url: user.avatar_url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .shadow(radius: 4)

            VStack(spacing: 4) {
                Text(user.login)
                    .font(.title2)
                    .bold()

                if let name = user.name, !name.isEmpty {
                    Text(name)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 40) {
                statView(title: "Repos", value: user.public_repos)
                statView(title: "Followers", value: user.followers)
            }
            .padding(.top, 8)

            Spacer()

            Button("Sign Out", role: .destructive) {
                viewModel.signOut()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    private func statView(title: String, value: Int) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.title3)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProfileView(authService: AuthService())
}
