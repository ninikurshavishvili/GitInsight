//
//  LanguagesCardView.swift
//  GitInsight
//

import SwiftUI

/// Card listing most-used programming languages with colored progress bars.
struct LanguagesCardView: View {
    let stats: [LanguageStat]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Languages")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            VStack(spacing: 14) {
                ForEach(stats) { stat in
                    LanguageRow(stat: stat)
                }
            }
        }
        .padding(16)
        .background(AppTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.card))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Language Row

private struct LanguageRow: View {
    let stat: LanguageStat

    var body: some View {
        VStack(spacing: 6) {
            // Name + percentage
            HStack {
                Circle()
                    .fill(stat.color)
                    .frame(width: 8, height: 8)

                Text(stat.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Spacer()

                Text(String(format: "%.0f%%", stat.percentage))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.06))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(stat.color)
                        .frame(width: geo.size.width * stat.percentage / 100)
                }
            }
            .frame(height: 5)
        }
    }
}

// MARK: - Preview

#Preview {
    LanguagesCardView(stats: [
        LanguageStat(name: "JavaScript", percentage: 42, color: Color(hex: 0xF7DF1E)),
        LanguageStat(name: "TypeScript", percentage: 28, color: Color(hex: 0x3178C6)),
        LanguageStat(name: "Rust",       percentage: 18, color: Color(hex: 0xDEA584)),
        LanguageStat(name: "PHP",        percentage: 12, color: Color(hex: 0x777BB4))
    ])
    .padding()
    .background(AppTheme.Colors.background)
}
