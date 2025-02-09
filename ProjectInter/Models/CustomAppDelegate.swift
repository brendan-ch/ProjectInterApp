//
//  GlobalNotificationsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.06.
//

import SwiftUI

// Class design subject to change

// See https://medium.com/@jpmtech/your-complete-guide-to-push-notifications-in-swiftui-8a13f5588662
// for example custom app delegate

class CustomAppDelegate: NSObject, ObservableObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        notificationCenter.delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(tokenString)
    }
    
    private func registerForRemoteNotificationsIfPermissionGranted(_ application: UIApplication) async {
//        let status = await getAuthorizationStatus()
//        if status == .authorized {
//            application.registerForRemoteNotifications()
//        }
    }
}
