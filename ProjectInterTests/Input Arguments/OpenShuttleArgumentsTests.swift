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
                "systemId": expected.systemId,
                "stopId": expected.stopId
            ]
        ]
        
        let arguments = try OpenShuttleArguments.constructArgumentsFromNotificationsUserInfo(userInfo: userInfo)
        
        #expect(arguments == expected)
    }
    
    @Test func testConstructArgumentsWithMissingKeyNotificationThrows() async throws {
        let badUserInfo: [String: Any] = [
            "someRandomKey": "someRandomValue"
            // doesn't have the relevant key
        ]
        
        #expect(throws: OpenShuttleArguments.ParseError.invalidArguments) {
            _ = try OpenShuttleArguments.constructArgumentsFromNotificationsUserInfo(userInfo: badUserInfo)
        }
    }
    
    @Test func testConstructArgumentWithMissingValuesNotificationThrows() async throws {
        let badUserInfo: [String: Any] = [
            UNNotificationResponse.shuttleNotificationInfoKey: [
                "shuttleId": "1",
                "systemId": "1"
            ]
        ]
        
        #expect(throws: OpenShuttleArguments.ParseError.invalidArguments) {
            _ = try OpenShuttleArguments.constructArgumentsFromNotificationsUserInfo(userInfo: badUserInfo)
        }
    }
}
