//
//  LoginView.swift
//  GitInsight
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        ZStack {
            
            // Background
            Color(hex: 0x10141A)
                .ignoresSafeArea()

            // Decorative blurred gradient circles
            DecorativeBackground()

            // Center card content
            VStack(spacing: 28) {
                LogoClusterView()

                TitleBlockView()

                DecorativeBarsView()

                GitHubLoginButton {
                    authService.signInWithGitHub()
                }

                DisclaimerView()

                SecurityBadgeRow()

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 420)
            .frame(maxHeight: .infinity, alignment: .center)

            // Footer pinned to bottom
            VStack {
                Spacer()
                FooterView()
                    .padding(.bottom, 28)
            }
            .padding(.horizontal, 24)
        }
    }
}



// MARK: - Logo

struct LogoClusterView: View {
    var body: some View {
        ZStack {
            // Glow
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.accentGreen.opacity(0.8),
                            Color.accentGreen2.opacity(0.55)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 92, height: 92)
                .blur(radius: 18)
                .opacity(0.25)

            // Container
            Circle()
                .fill(Color.surfaceLow)
                .frame(width: 88, height: 88)
                .overlay(
                    Circle().stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.45), radius: 18, x: 0, y: 10)

            // “Terminal” icon (SF Symbol approximation)
            Image(systemName: "terminal.fill")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(Color.accentGreen)
        }
        .padding(.top, 6)
        .accessibilityLabel("GitInsight logo")
    }
}














