//
//  WebViewCacheClearer.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.05.
//

import WebKit

struct WebViewCacheClearer {
    static func clearWebViewCache() async {
        let dataStore = await WKWebsiteDataStore.default()
        let types = await WKWebsiteDataStore.allWebsiteDataTypes()
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                dataStore.removeData(ofTypes: types, modifiedSince: Date.distantPast) {
                    continuation.resume()
                }
            }
        }
    }
}
