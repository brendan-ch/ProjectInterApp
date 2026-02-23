//
//  URL.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.10.03.
//

import Foundation

extension URL {
    /// Resolves the API base URL by checking UserDefaults for a custom value first,
    /// falling back to the provided default.
    static func resolvedApiBaseUrl(
        from userDefaults: UserDefaults? = .group,
        fallback: URL = URL(string: BundleClass().bundle.object(forInfoDictionaryKey: "API_BASE_URL") as! String)!
    ) -> URL {
        if let customUrlString = userDefaults?.string(forKey: UserDefaults.customServerUrlKey),
           !customUrlString.isEmpty,
           let customUrl = URL(string: customUrlString) {
            return customUrl
        }
        return fallback
    }

    static var apiBaseUrl: URL { resolvedApiBaseUrl() }

    /// The default API base URL from Info.plist, ignoring any user override.
    static var defaultApiBaseUrl: URL {
        URL(string: BundleClass().bundle.object(forInfoDictionaryKey: "API_BASE_URL") as! String)!
    }
}
