//
//  SecurityBadgeRow.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 16.04.26.
//

import SwiftUI

struct SecurityBadgeRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Badge(icon: "lock.fill", text: "Secure")

            Circle()
                .fill(Color.outlineVariant)
                .frame(width: 4, height: 4)

            Badge(icon: "checkmark.shield.fill", text: "Read-only")
        }
        .font(.system(size: 12, weight: .medium))
        .foregroundStyle(Color.textMuted.opacity(0.7))
        .padding(.top, 6)
    }

    private struct Badge: View {
        let icon: String
        let text: String

        var body: some View {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(text)
            }
        }
    }
}
