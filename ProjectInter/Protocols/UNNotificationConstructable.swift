//
//  UNNotificationConstructable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation
import UserNotifications

enum UNNotificationConstructableError: Swift.Error {
    case missingNotificationsUserInfo
    case invalidDictionaryRepresentation
}

protocol UNNotificationConstructable: DictionaryConstructable {
    init(notification response: UNNotificationResponse) throws
    static func constructFromNotificationsUserInfo(userInfo: [String: Any]) throws -> Self
}

extension UNNotificationConstructable {
    init(notification response: UNNotificationResponse) throws {
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
            throw UNNotificationConstructableError.missingNotificationsUserInfo
        }
        self = try Self.constructFromNotificationsUserInfo(userInfo: userInfo)
    }
    
    static func constructFromNotificationsUserInfo(userInfo: [String: Any]) throws -> Self {
        guard let queryParams = userInfo.first(where: { $0.key == UNNotificationResponse.shuttleNotificationInfoKey })?.value else {
            throw UNNotificationConstructableError.invalidDictionaryRepresentation
        }
        
        return try constructFromDict(params: queryParams)
    }
}
