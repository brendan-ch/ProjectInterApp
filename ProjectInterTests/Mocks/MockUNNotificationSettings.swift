//
//  MockUNNotificationSettings.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import UserNotifications

class MockUNNotificationSettings: UNNotificationSettingsProtocol {
    var authorizationStatus: UNAuthorizationStatus = .notDetermined
}
