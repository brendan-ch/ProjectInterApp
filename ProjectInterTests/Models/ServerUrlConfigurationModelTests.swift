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
    @Test func applyServerUrl_withValidUrl_storesAndReconfigures() {
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

    @Test func applyServerUrl_withEmptyString_resetsToDefault() {
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

    @Test func applyServerUrl_withInvalidUrl_returnsFalse() {
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

    @Test func resetToDefault_removesCustomUrl() {
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

    @Test func isUsingCustomUrl_reflectsState() {
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

    @Test func customServerUrlString_readsFromUserDefaults() {
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

    @Test func customServerUrlString_returnsEmptyWhenNotSet() {
        let userDefaults = MockUserDefaults()
        let client = MockApolloClient()
        let apolloModel = ApolloNetworkModel(client: client)
        let model = ServerUrlConfigurationModel(
            userDefaults: userDefaults,
            apolloNetworkModel: apolloModel
        )

        #expect(model.customServerUrlString == "")
    }

    @Test func applyServerUrl_trimsWhitespace() {
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
