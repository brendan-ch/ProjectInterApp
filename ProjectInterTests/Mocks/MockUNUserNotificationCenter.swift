//
//  MockUNUserNotificationCenter.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import UserNotifications

// See https://stackoverflow.com/questions/40862551/unit-testing-ios-10-notifications
// for an explanation behind this design

class MockUNUserNotificationCenter: UNUserNotificationCenterProtocol {
    // MARK: Controls for authorization
    var shouldBeAuthorized = true
    
    init() {
    }
    
    func requestAuthorization(options: UNAuthorizationOptions = []) async throws -> Bool {
        return shouldBeAuthorized
    }
}
