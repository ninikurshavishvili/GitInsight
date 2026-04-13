import SwiftUI

struct GitHubMark: View {
    var body: some View {
        Image(systemName: "chevron.left.forwardslash.chevron.right")
            .resizable()
            .scaledToFit()
            .fontWeight(.bold)
            .foregroundStyle(Color(hex: 0xDFE2EB))
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.03))
            )
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        GitHubMark()
            .frame(width: 42, height: 42)
    }
    .preferredColorScheme(.dark)
}
