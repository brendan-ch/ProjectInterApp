//
//  OpenShuttleArgumentsTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Testing
import UserNotifications
@testable import ProjectInter

class OpenShuttleArgumentsTests {
    @Test func testConstructArgumentsWithValidNotificationConstructsArguments() async throws {
        let expected = OpenShuttleArguments(shuttleId: "263", systemId: "1", stopId: "110")
        let userInfo: [String: Any] = [
            UNNotificationResponse.shuttleNotificationInfoKey: [
                "shuttleId": expected.shuttleId,
                "stopId": expected.stopId,
                "systemId": expected.systemId,
            ]
        ]
        
        let arguments = try OpenShuttleArguments.constructFromNotificationsUserInfo(userInfo: userInfo)
        
        #expect(arguments == expected)
    }
    
    @Test func testConstructArgumentsWithMissingKeyNotificationThrows() async throws {
        let badUserInfo: [String: Any] = [
            "someRandomKey": "someRandomValue"
            // doesn't have the relevant key
        ]
        
        #expect(throws: OpenShuttleArguments.ParseError.invalidDictionaryRepresentation) {
            _ = try OpenShuttleArguments.constructFromNotificationsUserInfo(userInfo: badUserInfo)
        }
    }
    
    @Test func testConstructArgumentWithMissingValuesNotificationThrows() async throws {
        let badUserInfo: [String: Any] = [
            UNNotificationResponse.shuttleNotificationInfoKey: [
                "shuttleId": "1",
                "systemId": "1"
            ]
        ]
        
        #expect(throws: DictionaryConstructableError.invalidArguments) {
            _ = try OpenShuttleArguments.constructFromNotificationsUserInfo(userInfo: badUserInfo)
        }
    }
    
    @Test func testConstructArgumentWithValidUrlConstructsArguments() async throws {
        let expected = OpenShuttleArguments(shuttleId: "1", systemId: "1", stopId: "1")
        let url = URL(string: "interchange://x-callback-url/openShuttle?stopId=1&shuttleId=1&systemId=1")!
        let arguments = try OpenShuttleArguments(url: url)
        #expect(expected == arguments)
    }
}
