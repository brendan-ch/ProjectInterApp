//
//  UNNotificationSettingsProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import UserNotifications

protocol UNNotificationSettingsProtocol: AnyObject {
    var authorizationStatus: UNAuthorizationStatus { get }
}
