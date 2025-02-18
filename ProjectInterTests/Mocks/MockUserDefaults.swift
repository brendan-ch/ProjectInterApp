//
//  MockUserDefaults.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import Foundation

class MockUserDefaults: UserDefaults {
    var mockBoolResponse = false
    var mockStringResponse = ""
    
    override func bool(forKey defaultName: String) -> Bool {
        return mockBoolResponse
    }
    
    override func string(forKey defaultName: String) -> String? {
        return mockStringResponse
    }
}
