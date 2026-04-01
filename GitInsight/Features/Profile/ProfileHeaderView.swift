//
//  ProfileHeaderView.swift
//  GitInsight
//

import SwiftUI

/// Profile header: avatar with gradient ring, username, membership badge, bio,
/// and Edit Profile / Share Resume action buttons.
struct ProfileHeaderView: View {
    let user: GitHubUser

    var body: some View {
        VStack(spacing: 16) {
            // Avatar with gradient border ring
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [AppTheme.Colors.accent, AppTheme.Colors.accentAlt],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 100, height: 100)

                AsyncImage(url: user.avatar_url) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    default:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
                .frame(width: 92, height: 92)
                .clipShape(Circle())
            }

            // Username + membership badge
            VStack(spacing: 8) {
                Text(user.login)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text("Pro Member")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(AppTheme.Colors.accent.opacity(0.12))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(AppTheme.Colors.accent.opacity(0.3), lineWidth: 1)
                    )
            }

            // Bio
            if let bio = user.bio, !bio.isEmpty {
                Text(bio)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 24)
            }

            // Action buttons
            HStack(spacing: 12) {
                ProfileActionButton(title: "Edit Profile", icon: "pencil", isPrimary: false) {}
                ProfileActionButton(title: "Share Resume", icon: "square.and.arrow.up", isPrimary: true) {}
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
    }
}

// MARK: - Action Button

private struct ProfileActionButton: View {
    let title: String
    let icon: String
    let isPrimary: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(isPrimary ? AppTheme.Colors.onPrimary : AppTheme.Colors.textPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 11)
            .background(
                Group {
                    if isPrimary {
                        LinearGradient(
                            colors: [AppTheme.Colors.accent, AppTheme.Colors.accent.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        LinearGradient(
                            colors: [AppTheme.Colors.surface, AppTheme.Colors.surface],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(
                    isPrimary ? Color.clear : AppTheme.Colors.outline,
                    lineWidth: 1
                )
            )
            .shadow(
                color: isPrimary ? AppTheme.Colors.accent.opacity(0.25) : .clear,
                radius: 10, x: 0, y: 4
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.94 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

#Preview {
    ProfileHeaderView(user: GitHubUser(
        id: 1,
        login: "ninikurshavishvili",
        name: "Nini Kurshavishvili",
        avatar_url: nil,
        bio: "iOS developer crafting beautiful apps with SwiftUI.",
        public_repos: 42,
        followers: 120,
        following: 55
    ))
    .background(AppTheme.Colors.background)
}
