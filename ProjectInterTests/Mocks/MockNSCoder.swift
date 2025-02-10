//
//  MockNSCoder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

// Implementation taken from https://gist.github.com/JonnyBeeGod/acb25823ab9511657e2e9c434898c08a

import UserNotifications

class MockNSCoder: NSCoder {
    var authorizationStatus = UNAuthorizationStatus.authorized.rawValue
    
    override func decodeInt64(forKey key: String) -> Int64 {
        return Int64(authorizationStatus)
    }
    
    override func decodeBool(forKey key: String) -> Bool {
        return true
    }
}
