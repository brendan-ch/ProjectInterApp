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
    
    enum ParseError: Swift.Error {
        case missingNotificationsUserInfo
        case missingArguments
        case invalidArguments
    }
    
    init(shuttleId: String, systemId: String, stopId: String) {
        self.shuttleId = shuttleId
        self.systemId = systemId
        self.stopId = stopId
    }
    
    init(notification response: UNNotificationResponse) throws {
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
            throw ParseError.missingNotificationsUserInfo
        }
        self = try OpenShuttleArguments.constructArgumentsFromNotificationsUserInfo(userInfo: userInfo)
    }
    
    static func constructArgumentsFromNotificationsUserInfo(userInfo: [String: Any]) throws -> OpenShuttleArguments {
        guard let shuttleNotificationInfo = userInfo.first(where: { $0.key == UNNotificationResponse.shuttleNotificationInfoKey })?.value else {
            throw ParseError.missingArguments
        }
        
        guard let jsonSerialization = try? JSONSerialization.data(withJSONObject: shuttleNotificationInfo, options: []),
              let decoded = try? JSONDecoder().decode(OpenShuttleArguments.self, from: jsonSerialization) else {
            throw ParseError.invalidArguments
        }
        
        return decoded
    }
}

