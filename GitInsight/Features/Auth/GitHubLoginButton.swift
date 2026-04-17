//
//  Untitled.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 17.04.26.
//

import SwiftUI

struct GitHubLoginButton: View {
    let action: () -> Void

    var body: some View {
        // Outer “padded rail” like the HTML: surface container low + inner gradient capsule
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: 12) {
                    GitHubMark()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color.onPrimary)

                    Text("Continue with GitHub")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.onPrimary)
                        .tracking(-0.2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(
                LinearGradient(
                    colors: [Color.accentGreen, Color.accentGreen2],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color.accentGreen.opacity(0.18), radius: 18, x: 0, y: 10)
            .scaleEffect(1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: UUID())
        }
        .padding(6)
        .background(Color.surfaceLow)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.35), radius: 14, x: 0, y: 10)
        .accessibilityLabel("Continue with GitHub")
    }
}
