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
        case missingUrlComponents
        case incorrectUrlHandler
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
        self = try OpenShuttleArguments.constructFromNotificationsUserInfo(userInfo: userInfo)
    }
    
    static func constructFromNotificationsUserInfo(userInfo: [String: Any]) throws -> OpenShuttleArguments {
        guard let queryParams = userInfo.first(where: { $0.key == UNNotificationResponse.shuttleNotificationInfoKey })?.value else {
            throw ParseError.invalidArguments
        }
        
        return try constructFromDict(params: queryParams)
    }
    
    static func constructFromDict(params: Any) throws -> OpenShuttleArguments {
        guard let jsonSerialization = try? JSONSerialization.data(withJSONObject: params, options: []),
              let decoded = try? JSONDecoder().decode(OpenShuttleArguments.self, from: jsonSerialization) else {
            throw ParseError.invalidArguments
        }
        
        return decoded
    }
    
    init(url: URL) throws {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw ParseError.missingUrlComponents
        }
        
        guard components.path == OpenShuttleArguments.expectedUrlPath else {
            throw ParseError.incorrectUrlHandler
        }
        
        guard let queryItemsDict = components.queryItems?.asDictionary() else {
            throw ParseError.invalidArguments
        }
        
        self = try OpenShuttleArguments.constructFromDict(params: queryItemsDict)
    }
}

extension OpenShuttleArguments {
    static var expectedUrlPath: String { "/openShuttle" }
}
