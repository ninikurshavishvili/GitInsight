import SwiftUI

struct GitHubLoginButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                GitHubMark()
                    .frame(width: 18, height: 18)

                Text("Continue with GitHub")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(Color(hex: 0x10141A))
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: 0x7BDB80), Color(hex: 0x69C96E)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
            )
            .shadow(color: Color(hex: 0x7BDB80, alpha: 0.35), radius: 18, x: 0, y: 8)
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        GitHubLoginButton(action: {})
            .padding(.horizontal, 24)
    }
    .preferredColorScheme(.dark)
}
