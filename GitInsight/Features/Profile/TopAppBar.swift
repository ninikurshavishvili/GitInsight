//
//  TopAppBar.swift
//  GitInsight
//

import SwiftUI

/// Top navigation bar with user avatar, app title, and a settings button.
struct TopAppBar: View {
    let avatarURL: URL?
    let onSettingsTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Avatar thumbnail
            AsyncImage(url: avatarURL) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(AppTheme.Colors.accent.opacity(0.45), lineWidth: 1.5)
            )

            // App title
            Text("GitInsight")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppTheme.Colors.accent, AppTheme.Colors.accent.opacity(0.65)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Spacer()

            // Settings button
            Button(action: onSettingsTap) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .padding(9)
                    .background(AppTheme.Colors.surface)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.06), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            AppTheme.Colors.surface
                .opacity(0.9)
                .overlay(Color.white.opacity(0.03))
        )
    }
}

// MARK: - Preview

#Preview {
    TopAppBar(avatarURL: nil, onSettingsTap: {})
        .background(AppTheme.Colors.background)
}
