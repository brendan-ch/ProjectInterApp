//
//  ServerUrlConfigurationModel.swift
//  ProjectInter
//
//  Created by Claude on 2026.02.23.
//

import SwiftUI
import Apollo
import ProjectInterShared
import ProjectInterLogging

/// Manages reading/writing the user-configured server URL.
@Observable
class ServerUrlConfigurationModel {
    let userDefaults: UserDefaults?

    /// Incremented each time the server URL is changed, so views can react.
    private(set) var urlVersion: Int = 0

    /// The user's custom server URL string, or nil if using default.
    /// Pass nil to reset to the default server URL.
    var customServerUrlString: String? {
        get {
            access(keyPath: \.customServerUrlString)
            return userDefaults?.string(forKey: UserDefaults.customServerUrlKey)
        }
        set {
            withMutation(keyPath: \.customServerUrlString) {
                if let newValue, !newValue.isEmpty {
                    userDefaults?.setValue(newValue, forKey: UserDefaults.customServerUrlKey)
                } else {
                    userDefaults?.removeObject(forKey: UserDefaults.customServerUrlKey)
                }
            }
        }
    }

    /// Whether the user has a custom server URL configured.
    var isUsingCustomUrl: Bool {
        customServerUrlString != nil
    }

    /// The currently active server URL (custom or default).
    var currentServerUrl: URL {
        URL.apiBaseUrl
    }

    convenience init() {
        self.init(userDefaults: UserDefaults.group)
    }

    init(userDefaults: UserDefaults?) {
        self.userDefaults = userDefaults
    }

    /// Apply a new server URL. Returns true if the URL is valid and was applied.
    /// Pass an empty string or nil to reset to default.
    @discardableResult
    func applyServerUrl(_ urlString: String) -> Bool {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return resetToDefault()
        }

        guard let url = URL(string: trimmed),
              let scheme = url.scheme,
              ["http", "https"].contains(scheme.lowercased()) else {
            return false
        }

        customServerUrlString = trimmed
        urlVersion += 1
        Loggers.shared.networkingLogger.notice("Server URL changed to: \(trimmed)")
        return true
    }

    /// Reset to the default server URL from Info.plist.
    @discardableResult
    func resetToDefault() -> Bool {
        customServerUrlString = nil
        urlVersion += 1
        Loggers.shared.networkingLogger.notice("Server URL reset to default")
        return true
    }
}
