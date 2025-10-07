//
//  URL.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.10.03.
//

import Foundation

extension URL {
    static var apiBaseUrl: URL { URL(string: BundleClass().bundle.object(forInfoDictionaryKey: "API_BASE_URL") as! String)! }
}
