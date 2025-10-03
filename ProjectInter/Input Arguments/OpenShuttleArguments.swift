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
struct OpenShuttleArguments: URLConstructable, Equatable {
    let shuttleId: String
    let systemId: String
    let stopId: String

    enum ParseError: Swift.Error {
        case missingNotificationsUserInfo
        case missingUrlComponents
        case incorrectUrlHandler
        case invalidDictionaryRepresentation
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
        self = try OpenShuttleArguments.constructFromNotificationsUserInfo(userInfo: userInfo)
    }
    
    static func constructFromNotificationsUserInfo(userInfo: [String: Any]) throws -> OpenShuttleArguments {
        guard let queryParams = userInfo.first(where: { $0.key == UNNotificationResponse.shuttleNotificationInfoKey })?.value else {
            throw ParseError.invalidDictionaryRepresentation
        }
        
        return try constructFromDict(params: queryParams)
    }
}

extension OpenShuttleArguments {
    static var expectedUrlPath: String { "/openShuttle" }
}
