//
//  KeychainService.swift
//  GitInsight
//

import Foundation
import Security

/// Provides secure Keychain read/write/delete operations for string values.
enum KeychainService {
    private static let service = "com.gitinsight.auth"

    /// Persists a string value in the Keychain under the given account key.
    nonisolated static func save(_ value: String, account: String) throws {
        let data = Data(value.utf8)

        // Delete any pre-existing item before inserting the new one.
        // errSecItemNotFound is expected when no prior item exists; other errors are ignored
        // because the subsequent SecItemAdd call will surface any real failure.
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    /// Reads a previously stored string value from the Keychain.
    /// Returns `nil` if no item is found.
    nonisolated static func read(account: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        guard let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Removes the stored item for the given account key (no-op if absent).
    nonisolated static func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - KeychainError

enum KeychainError: LocalizedError {
    case unexpectedStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .unexpectedStatus(let status):
            return "Keychain error: OSStatus \(status)"
        }
    }
}
