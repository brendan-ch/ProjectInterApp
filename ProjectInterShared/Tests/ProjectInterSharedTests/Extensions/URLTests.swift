//
//  URLTests.swift
//  ProjectInterShared
//
//  Created by Claude on 2026.02.23.
//

import Testing
import Foundation
@testable import ProjectInterShared

struct URLTests {
    let testDefaults = UserDefaults(suiteName: "dev.bchen.Inter.URLTests")!
    let fallbackUrl = URL(string: "https://default.example.com")!

    init() {
        testDefaults.removeObject(forKey: UserDefaults.customServerUrlKey)
    }

    @Test("resolvedApiBaseUrl returns custom URL when set")
    func resolvedApiBaseUrlReturnsCustomUrlWhenSet() {
        testDefaults.set("https://custom.example.com/graphql", forKey: UserDefaults.customServerUrlKey)
        let result = URL.resolvedApiBaseUrl(from: testDefaults, fallback: fallbackUrl)
        #expect(result == URL(string: "https://custom.example.com/graphql")!)
    }

    @Test("resolvedApiBaseUrl returns fallback when no custom URL")
    func resolvedApiBaseUrlReturnsFallbackWhenNoCustomUrl() {
        let result = URL.resolvedApiBaseUrl(from: testDefaults, fallback: fallbackUrl)
        #expect(result == fallbackUrl)
    }

    @Test("resolvedApiBaseUrl returns fallback when custom URL is empty")
    func resolvedApiBaseUrlReturnsFallbackWhenCustomUrlIsEmpty() {
        testDefaults.set("", forKey: UserDefaults.customServerUrlKey)
        let result = URL.resolvedApiBaseUrl(from: testDefaults, fallback: fallbackUrl)
        #expect(result == fallbackUrl)
    }

    @Test("resolvedApiBaseUrl returns fallback when custom URL is invalid")
    func resolvedApiBaseUrlReturnsFallbackWhenCustomUrlIsInvalid() {
        // A string with spaces is not a valid URL
        testDefaults.set("not a valid url", forKey: UserDefaults.customServerUrlKey)
        let result = URL.resolvedApiBaseUrl(from: testDefaults, fallback: fallbackUrl)
        #expect(result == fallbackUrl)
    }

    @Test("resolvedApiBaseUrl returns fallback when UserDefaults is nil")
    func resolvedApiBaseUrlReturnsFallbackWhenUserDefaultsIsNil() {
        let result = URL.resolvedApiBaseUrl(from: nil, fallback: fallbackUrl)
        #expect(result == fallbackUrl)
    }
}
