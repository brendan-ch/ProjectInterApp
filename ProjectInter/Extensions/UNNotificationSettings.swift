//
//  UNNotificationSettings.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import UserNotifications

extension UNNotificationSettings {
    static var fakeAuthorizationStatus: UNAuthorizationStatus = .notDetermined
        
    static func swizzleAuthorizationStatus() {
        let originalMethod = class_getInstanceMethod(self, #selector(getter: authorizationStatus))!
        let swizzledMethod = class_getInstanceMethod(self, #selector(getter: swizzledAuthorizationStatus))!
    
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc var swizzledAuthorizationStatus: UNAuthorizationStatus {
        return Self.fakeAuthorizationStatus
    }
}
