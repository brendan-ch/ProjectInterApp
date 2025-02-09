//
//  GlobalNotificationsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.06.
//

import SwiftUI

// Class design subject to change

class GlobalNotificationsModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() async {
        do {
            try await notificationCenter.requestAuthorization(options: [
                .alert,
                .sound
            ])
            
        } catch {
            print(error)
        }
        
    }
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        var settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
}
