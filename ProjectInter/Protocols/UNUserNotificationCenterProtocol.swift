//
//  UNUserNotificationCenterProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import UserNotifications

/// Protocol wrapper around ``UNUserNotificationCenter`` to enable a mock implementation
/// of the class.
protocol UNUserNotificationCenterProtocol: AnyObject {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func notificationSettings() async -> UNNotificationSettings
    var delegate: UNUserNotificationCenterDelegate? { get set }
}
