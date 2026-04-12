import SwiftUI

struct LogoClusterView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: 0x1A2030), Color(hex: 0x121722)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                .frame(width: 94, height: 94)
                .shadow(color: Color.black.opacity(0.35), radius: 24, x: 0, y: 12)

            GitHubMark()
                .frame(width: 42, height: 42)
        }
        .padding(.top, 8)
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        LogoClusterView()
    }
    .preferredColorScheme(.dark)
}
