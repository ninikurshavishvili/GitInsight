//
//  GitHubAuthConfig.swift
//  GitInsight
//
//  Created by Nini Kurshavishvili on 30.03.26.
//

import Foundation

/// Centralized GitHub OAuth configuration.
/// Keep these values in sync with:
/// - GitHub App / OAuth settings
/// - Xcode target URL Types (scheme)
enum GitHubAuthConfig {
    /// Use the real Client ID (provided by you).
    static let clientID: String = "Iv23liRr17EyHxDQmoYv"

    /// Must match what you pass to GitHub in `redirect_uri`
    /// and must be registered in the iOS app's URL Types.
    static let redirectURI: String = "gitinsight://oauth-callback"

    /// ASWebAuthenticationSession listens for only the scheme part.
    static let callbackURLScheme: String = "gitinsight"

    /// Adjust if you need more permissions later.
    static let scope: String = "read:user"
}
