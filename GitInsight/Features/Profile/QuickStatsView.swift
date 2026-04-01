//
//  QuickStatsView.swift
//  GitInsight
//

import SwiftUI

/// Side-by-side stat cards showing total commits and repository count.
struct QuickStatsView: View {
    let totalCommits: Int
    let totalRepos: Int

    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "arrow.triangle.branch",
                value: formattedCommits,
                label: "Total Commits",
                accentColor: AppTheme.Colors.accent
            )

            StatCard(
                icon: "folder.fill",
                value: "\(totalRepos)",
                label: "Total Repos",
                accentColor: AppTheme.Colors.accentAlt
            )
        }
    }

    private var formattedCommits: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: totalCommits)) ?? "\(totalCommits)"
    }
}

// MARK: - Stat Card

private struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon chip
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(accentColor)
                .padding(10)
                .background(accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // Numbers
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            ZStack(alignment: .topLeading) {
                AppTheme.Colors.surface
                LinearGradient(
                    colors: [accentColor.opacity(0.07), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview

#Preview {
    QuickStatsView(totalCommits: 2_847, totalRepos: 42)
        .padding()
        .background(AppTheme.Colors.background)
}
