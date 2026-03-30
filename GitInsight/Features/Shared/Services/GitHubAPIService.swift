//
//  GitHubAPIService.swift
//  GitInsight
//

import Foundation

/// Wraps GitHub REST API calls using `URLSession`.
enum GitHubAPIService {

    /// Fetches the authenticated user's profile from `GET /user`.
    ///
    /// - Parameter accessToken: A valid GitHub OAuth access token.
    /// - Returns: The decoded `GitHubUser` on success.
    /// - Throws: `URLError` or a descriptive `NSError` on HTTP / decoding failures.
    nonisolated static func fetchAuthenticatedUser(accessToken: String) async throws -> GitHubUser {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "(empty)"
            throw NSError(
                domain: "GitHubAPIService",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "GitHub /user failed (\(http.statusCode)): \(body)"]
            )
        }

        return try JSONDecoder().decode(GitHubUser.self, from: data)
    }
}
