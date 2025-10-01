//
//  GlobalNotificationsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.06.
//

import SwiftUI
import ProjectInterLogging

// See https://medium.com/@jpmtech/your-complete-guide-to-push-notifications-in-swiftui-8a13f5588662
// for example custom app delegate

class CustomAppDelegate: NSObject, ObservableObject, UIApplicationDelegate {
    @Published var notificationTokenString: String?
    @Published var notificationCenterDelegate = CustomNotificationCenterDelegate()
    
    override init() {
        super.init()
        
        let shouldUseMockToken = UserDefaults.standard.bool(forKey: UserDefaults.mockNotificationsTokenKey)
        if shouldUseMockToken {
            notificationTokenString = "mock-device"
            Loggers.shared.systemEventsLogger.debug("Using mock notification token")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Task {
            await registerForRemoteNotificationsIfPermissionGranted(UIApplication.shared)
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Loggers.shared.systemEventsLogger.notice("Notification token string created and saved")
        Loggers.shared.systemEventsLogger.debug("\(self.notificationTokenString ?? "No token string in state")")
    }
    
    func requestNotificationAuthorizationAndRegisterIfGranted() async {
        await notificationCenterDelegate.requestAuthorization()
        await registerForRemoteNotificationsIfPermissionGranted(UIApplication.shared)
    }
    
    private func registerForRemoteNotificationsIfPermissionGranted(_ application: UIApplication) async {
        Loggers.shared.systemEventsLogger.notice("Waiting for notification authorization status...")
        let status = await notificationCenterDelegate.getAuthorizationStatus()
        if status == .authorized {
            application.registerForRemoteNotifications()
        }
        Loggers.shared.systemEventsLogger.notice("Notifications not authorized, skipping registration")
    }
}
