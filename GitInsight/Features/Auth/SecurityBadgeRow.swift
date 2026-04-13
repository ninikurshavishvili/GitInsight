import SwiftUI

struct SecurityBadgeRow: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.shield")
                .font(.system(size: 12, weight: .semibold))

            Text("OAuth via GitHub")
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundStyle(Color(hex: 0x7C8AA0))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.04))
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        SecurityBadgeRow()
    }
    .preferredColorScheme(.dark)
}
