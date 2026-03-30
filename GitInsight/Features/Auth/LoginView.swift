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

// MARK: - Background

private struct DecorativeBackground: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentGreen.opacity(0.08))
                .frame(width: 420, height: 420)
                .blur(radius: 90)
                .offset(x: -140, y: -240)

            Circle()
                .fill(Color.secondaryBlue.opacity(0.07))
                .frame(width: 340, height: 340)
                .blur(radius: 80)
                .offset(x: 160, y: 280)
        }
        .allowsHitTesting(false)
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

// MARK: - Footer

private struct FooterView: View {
    var body: some View {
        Text("Built for developers by developers")
            .font(.system(size: 10, weight: .medium))
            .textCase(.uppercase)
            .tracking(1.6)
            .foregroundStyle(Color.textMuted.opacity(0.35))
            .frame(maxWidth: .infinity, alignment: .center)
            .accessibilityLabel("Built for developers by developers")
    }
}

// MARK: - GitHub Mark (simple)

private struct GitHubMark: View {
    var body: some View {
        // Simple SF Symbol fallback. (No WebKit; no SVG parsing.)
        // If you later add an asset named "github-mark", swap to Image("github-mark").
        Image(systemName: "circle.hexagongrid.fill")
            .font(.system(size: 20, weight: .semibold))
    }
}

// MARK: - Colors & Helpers

private extension Color {
    static let accentGreen = Color(hex: 0x7BDB80)       // #7bdb80
    static let accentGreen2 = Color(hex: 0x238636)      // GitHub-ish darker green

    static let secondaryBlue = Color(hex: 0xAFC6FF)

    static let surfaceLow = Color(hex: 0x181C22)        // surface-container-low-ish
    static let textMuted = Color(hex: 0xBECABA)         // on-surface-variant-ish
    static let outlineVariant = Color(hex: 0x3F4A3D)
    static let onPrimary = Color(hex: 0x00390E)         // from tailwind config on-primary
}

private extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
