//
//  MockUserDefaults.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import Foundation

class MockUserDefaults: UserDefaults {
    var lastKeySetTo: String?
    var lastValueSetTo: Any?
    
    var values: [String: Any] = [:]
    
    override func bool(forKey defaultName: String) -> Bool {
        return values[defaultName] as? Bool ?? false
    }
    
    override func string(forKey defaultName: String) -> String? {
        return values[defaultName] as? String
    }
    
    override func value(forKey defaultName: String) -> Any? {
        return values[defaultName] as Any?
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        lastKeySetTo = key
        lastValueSetTo = value
        
        values[key] = value
    }
    
    override func removeObject(forKey key: String) {
        values[key] = nil
    }
}
