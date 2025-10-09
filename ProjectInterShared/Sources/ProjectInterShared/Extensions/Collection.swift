//
//  Collection.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation

extension Collection where Element == URLQueryItem {
    func value(for name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
    
    func asDictionary() -> [String: String] {
        reduce(into: [:]) { dict, item in
            if let value = item.value { dict[item.name] = value }
        }
    }
}
