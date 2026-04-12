import SwiftUI

struct DecorativeBarsView: View {
    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 999)
                .fill(Color(hex: 0x7BDB80))
                .frame(width: 44, height: 4)

            RoundedRectangle(cornerRadius: 999)
                .fill(Color.white.opacity(0.12))
                .frame(width: 20, height: 4)

            RoundedRectangle(cornerRadius: 999)
                .fill(Color.white.opacity(0.12))
                .frame(width: 20, height: 4)
        }
    }
}

#Preview {
    ZStack {
        Color(hex: 0x10141A).ignoresSafeArea()
        DecorativeBarsView()
    }
    .preferredColorScheme(.dark)
}
