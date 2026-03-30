//
//  RootView.swift
//  GitInsight
//

import SwiftUI


struct RootView: View {
    @EnvironmentObject private var authService: AuthService

    var body: some View {
        Group {
            if authService.currentUser != nil {
                ProfileView(authService: AuthService())
            } else {
                LoginView()
            }
        }
        .task {
            await authService.loadUserIfTokenExists()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthService())
}
