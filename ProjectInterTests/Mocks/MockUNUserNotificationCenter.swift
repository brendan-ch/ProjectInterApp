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
    var delegate: (any UNUserNotificationCenterDelegate)?
    var settings: UNNotificationSettings
    
    init() {
        settings = UNNotificationSettings(coder: MockNSCoder())!
        UNNotificationSettings.swizzleAuthorizationStatus()
    }
    
    func requestAuthorization(options: UNAuthorizationOptions = []) async throws -> Bool {
        UNNotificationSettings.fakeAuthorizationStatus = .authorized
        return true
    }
    
    func notificationSettings() async -> UNNotificationSettings {
        return settings
    }
}
