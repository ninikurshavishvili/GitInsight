//
//  LoginView.swift
//  GitInsight
//

import SwiftUI

/// The unauthenticated landing screen with a "Continue with GitHub" button.
struct LoginView: View {

    @StateObject private var viewModel: LoginViewModel

    init(authService: AuthService) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 60))
                .foregroundStyle(.accent)

            Text("GitInsight")
                .font(.largeTitle)
                .bold()

            Text("Analyze your GitHub activity")
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                viewModel.signIn()
            } label: {
                Label("Continue with GitHub", systemImage: "person.crop.circle.badge.checkmark")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
            }

            if let message = viewModel.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    LoginView(authService: AuthService())
}
