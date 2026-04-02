import Foundation
import Combine
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var username: String = ""
    @Published private(set) var fullName: String = ""
    @Published private(set) var avatarURL: URL?

    private let authService: AuthService
    private var cancellables: Set<AnyCancellable> = []

    init(authService: AuthService) {
        self.authService = authService

        // Observe current user and map into lighter view state.
        authService.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.username = user?.login ?? ""
                self?.fullName = user?.name ?? ""
                self?.avatarURL = user?.avatar_url
            }
            .store(in: &cancellables)
    }

    func signOut() {
        authService.signOut()
    }
}
