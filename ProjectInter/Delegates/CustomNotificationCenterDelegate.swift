//
//  CustomNotificationCenterDelegate.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import Foundation
import UserNotifications
import UIKit

class CustomNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    private var notificationCenter: UNUserNotificationCenterProtocol
    
    override init() {
        notificationCenter = UNUserNotificationCenter.current()
        super.init()
        notificationCenter.delegate = self
    }
    
    init(notificationCenter: UNUserNotificationCenterProtocol) {
        self.notificationCenter = notificationCenter
        super.init()
        self.notificationCenter.delegate = self
    }
    
    func requestAuthorization() async {
        try? await notificationCenter.requestAuthorization(
            options: [.alert, .sound]
        )
    }
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        var settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return .banner
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // TODO: Set selected shuttle ID in this delegate so that the global data model can be updated
        // See https://www.notion.so/bchendev/Navigate-user-to-selected-shuttle-on-notification-click-1ca07b1035c680c0a109d5c80df2cac1?pvs=4
    }
}
