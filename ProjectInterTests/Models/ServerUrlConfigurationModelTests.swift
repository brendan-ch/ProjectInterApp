//
//  ServerUrlConfigurationModelTests.swift
//  ProjectInter
//
//  Created by Claude on 2026.02.23.
//

import Testing
@testable import ProjectInter
import Foundation
import ProjectInterShared

class ServerUrlConfigurationModelTests {
    @Test("applyServerUrl with valid URL stores and reconfigures") func applyServerUrlWithValidUrlStoresAndReconfigures() {
        let userDefaults = MockUserDefaults()
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        let result = model.applyServerUrl("https://custom.example.com/graphql")

        #expect(result == true)
        #expect(userDefaults.values[UserDefaults.customServerUrlKey] as? String == "https://custom.example.com/graphql")
        #expect(model.isUsingCustomUrl == true)
        #expect(model.urlVersion == 1)
    }

    @Test("applyServerUrl with empty string resets to default") func applyServerUrlWithEmptyStringResetsToDefault() {
        let userDefaults = MockUserDefaults()
        userDefaults.setValue("https://custom.example.com", forKey: UserDefaults.customServerUrlKey)
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        let result = model.applyServerUrl("")

        #expect(result == true)
        #expect(model.isUsingCustomUrl == false)
        #expect(model.urlVersion == 1)
    }

    @Test("applyServerUrl with invalid URL returns false") func applyServerUrlWithInvalidUrlReturnsFalse() {
        let userDefaults = MockUserDefaults()
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        let result = model.applyServerUrl("not a valid url")

        #expect(result == false)
        #expect(model.isUsingCustomUrl == false)
        #expect(model.urlVersion == 0)
    }

    @Test("resetToDefault removes custom URL") func resetToDefaultRemovesCustomUrl() {
        let userDefaults = MockUserDefaults()
        userDefaults.setValue("https://custom.example.com", forKey: UserDefaults.customServerUrlKey)
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        let result = model.resetToDefault()

        #expect(result == true)
        #expect(model.isUsingCustomUrl == false)
        #expect(userDefaults.values[UserDefaults.customServerUrlKey] == nil)
        #expect(model.urlVersion == 1)
    }

    @Test("isUsingCustomUrl reflects state") func isUsingCustomUrlReflectsState() {
        let userDefaults = MockUserDefaults()
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        #expect(model.isUsingCustomUrl == false)

        model.applyServerUrl("https://custom.example.com")
        #expect(model.isUsingCustomUrl == true)

        model.resetToDefault()
        #expect(model.isUsingCustomUrl == false)
    }

    @Test("customServerUrlString reads from UserDefaults") func customServerUrlStringReadsFromUserDefaults() {
        let userDefaults = MockUserDefaults()
        userDefaults.setValue("https://stored.example.com", forKey: UserDefaults.customServerUrlKey)
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        #expect(model.customServerUrlString == "https://stored.example.com")
    }

    @Test("customServerUrlString returns empty when not set") func customServerUrlStringReturnsEmptyWhenNotSet() {
        let userDefaults = MockUserDefaults()
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        #expect(model.customServerUrlString == "")
    }

    @Test("applyServerUrl trims whitespace") func applyServerUrlTrimsWhitespace() {
        let userDefaults = MockUserDefaults()
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        let result = model.applyServerUrl("  https://custom.example.com  ")

        #expect(result == true)
        #expect(userDefaults.values[UserDefaults.customServerUrlKey] as? String == "https://custom.example.com")
    }
}
