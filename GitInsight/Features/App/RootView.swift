//
//  RootView.swift
//  GitInsight
//

import SwiftUI

/// The application's root router.
/// Observes `AuthService` and presents `LoginView` or `ProfileView`
/// depending on whether a current user is loaded.
struct RootView: View {

    @EnvironmentObject private var authService: AuthService

    var body: some View {
        Group {
            if authService.currentUser != nil {
                ProfileView(authService: authService)
            } else {
                LoginView(authService: _authService)
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
