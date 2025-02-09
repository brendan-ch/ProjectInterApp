//
//  CustomNotificationCenterDelegate.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import Foundation
import UserNotifications

class CustomNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    private var notificationCenter: UNUserNotificationCenter
    
    override init() {
        notificationCenter = UNUserNotificationCenter.current()
        super.init()
        notificationCenter.delegate = self
    }
    
    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
        super.init()
        self.notificationCenter.delegate = self
    }
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        var settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
}
