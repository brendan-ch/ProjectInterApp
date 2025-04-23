//
//  CustomNotificationCenterDelegate.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import Foundation
import UserNotifications
import UIKit

struct LastTappedNotificationDetails: Codable, Equatable {
    let shuttleId: String
    let systemId: String
    let stopId: String
}

class CustomNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    private var notificationCenter: UNUserNotificationCenterProtocol
    
    @Published var lastTappedNotificationDetails: LastTappedNotificationDetails?
    
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
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    // Using callback-based APIs to work around crash related to
    // things not being on the main thread
    // https://developer.apple.com/forums/thread/735651
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
    
    // TODO: Validate this behavior via a UI test
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let shuttleNotificationInfo = userInfo.first { $0.key as? String == UNNotificationResponse.shuttleNotificationInfoKey }?.value
        guard let shuttleNotificationInfo else { return }
        
        let jsonSerialization = try? JSONSerialization.data(withJSONObject: shuttleNotificationInfo, options: [])
        guard let jsonSerialization else { return }
        let decoded = try? JSONDecoder().decode(LastTappedNotificationDetails.self, from: jsonSerialization)
        guard let decoded else { return }
        
        lastTappedNotificationDetails = decoded
    }
}
