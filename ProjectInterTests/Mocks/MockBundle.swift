//
//  MockBundle.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import Foundation

class MockBundle: Bundle, @unchecked Sendable {
    var mockedVersionNumber: String = ""
    
    override func object(forInfoDictionaryKey key: String) -> Any? {
        if key == "CFBundleShortVersionString" {
            return mockedVersionNumber
        }
        return super.object(forInfoDictionaryKey: key)
    }
}
