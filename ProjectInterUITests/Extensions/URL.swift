//
//  URL.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.07.05.
//

import Foundation

class BundleClass {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
}

extension URL {
    static var mockApiBaseUrl: URL { URL(string: BundleClass().bundle.object(forInfoDictionaryKey: "MOCK_API_BASE_URL") as! String)! }
}
