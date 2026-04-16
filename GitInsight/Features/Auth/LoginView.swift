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

// MARK: - Title

private struct TitleBlockView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("GitInsight")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .tracking(-1.0)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.accentGreen, Color.accentGreen2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Track and analyze your GitHub activity")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.textMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .frame(maxWidth: 300)
        }
    }
}

// MARK: - Decorative Bars

private struct DecorativeBarsView: View {
    var body: some View {
        HStack(spacing: 8) {
            Capsule().fill(Color.accentGreen.opacity(0.20)).frame(width: 34, height: 8)
            Capsule().fill(Color.accentGreen.opacity(0.40)).frame(width: 46, height: 8)
            Capsule().fill(Color.accentGreen.opacity(0.12)).frame(width: 26, height: 8)
            Capsule().fill(Color.accentGreen.opacity(0.30)).frame(width: 40, height: 8)
        }
        .padding(.vertical, 6)
        .accessibilityHidden(true)
    }
}

// MARK: - Button

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

// MARK: - Disclaimer + badges

struct DisclaimerView: View {
    var body: some View {
        Text("GitInsight will access your public GitHub activity, including repository names, commit timestamps, and contribution statistics to build your analytics dashboard.")
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(Color.textMuted.opacity(0.9))
            .multilineTextAlignment(.center)
            .lineSpacing(3)
            .frame(maxWidth: 320)
            .padding(.top, 2)
    }
}






