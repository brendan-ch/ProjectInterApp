//
//  OpenShuttleArguments.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation
import UserNotifications

/// Arguments needed for the app to open a shuttle, say,
/// from a URL or notification.
struct OpenShuttleArguments: Codable, Equatable {
    let shuttleId: String
    let systemId: String
    let stopId: String
    
    init(shuttleId: String, systemId: String, stopId: String) {
        self.shuttleId = shuttleId
        self.systemId = systemId
        self.stopId = stopId
    }
    
    init(notification response: UNNotificationResponse) throws {
        let userInfo = response.notification.request.content.userInfo
        let shuttleNotificationInfo = userInfo.first { $0.key as! String == UNNotificationResponse.shuttleNotificationInfoKey }?.value
        
        let jsonSerialization = try JSONSerialization.data(withJSONObject: shuttleNotificationInfo ?? "", options: [])
        
        let decoded = try JSONDecoder().decode(OpenShuttleArguments.self, from: jsonSerialization)
        self = decoded
    }
}

