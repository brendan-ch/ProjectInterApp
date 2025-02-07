//
//  GlobalNotificationsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.06.
//

import SwiftUI

// Class design subject to change

class GlobalNotificationsModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var authorizationStatus: UNAuthorizationStatus?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [
                .alert,
                .sound
            ])
            
        } catch {
            print(error)
        }
        
        var settings = await UNUserNotificationCenter.current().notificationSettings()
        self.authorizationStatus = settings.authorizationStatus
    }
}
