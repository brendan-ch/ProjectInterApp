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

class CustomAppDelegate: NSObject, ObservableObject, UIApplicationDelegate {
    @Published var notificationTokenString: String?
    private var notificationCenterDelegate = CustomNotificationCenterDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Task {
            await notificationCenterDelegate.requestAuthorization()
            await registerForRemoteNotificationsIfPermissionGranted(application)
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(notificationTokenString ?? "No token assigned")
    }
    
    private func registerForRemoteNotificationsIfPermissionGranted(_ application: UIApplication) async {
        let status = await notificationCenterDelegate.getAuthorizationStatus()
        if status == .authorized {
            application.registerForRemoteNotifications()
        }
    }
}
