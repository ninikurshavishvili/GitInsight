import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss

    init(authService: AuthService) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(authService: authService))
    }

    var body: some View {
        ZStack {
            // Dark developer-style background
            Color(hex: 0x10141A).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header / title
                    HStack {
                        Text("Settings")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: 0xDFE2EB))
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(Color(hex: 0xBECABA))
                                .padding(8)
                                .background(Color(hex: 0x181C22))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)

                    // Account section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Account")
                            .font(.headline)
                            .foregroundStyle(Color(hex: 0xDFE2EB))

                        HStack(spacing: 12) {
                            AsyncImage(url: viewModel.avatarURL) { phase in
                                switch phase {
                                case .success(let img):
                                    img.resizable().scaledToFill()
                                default:
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .foregroundStyle(Color(hex: 0xBECABA))
                                }
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.04), lineWidth: 1))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.fullName.isEmpty ? "—" : viewModel.fullName)
                                    .foregroundStyle(Color(hex: 0xDFE2EB))
                                    .font(.subheadline)
                                    .bold()

                                Text(viewModel.username.isEmpty ? "@unknown" : "@\(viewModel.username)")
                                    .foregroundStyle(Color(hex: 0xBECABA))
                                    .font(.caption)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color(hex: 0x181C22))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.03), lineWidth: 1))
                    }
                    .padding(.horizontal, 20)

                    // Actions section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Actions")
                            .font(.headline)
                            .foregroundStyle(Color(hex: 0xDFE2EB))

                        Button(role: .destructive) {
                            viewModel.signOut()
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .foregroundStyle(Color.white)
                                .background(Color.clear)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .controlSize(.large)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .padding(.bottom, 36)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsView(authService: AuthService())
}
