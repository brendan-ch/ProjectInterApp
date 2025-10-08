//
//  DictionaryConstructable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation

enum DictionaryConstructableError: Swift.Error {
    case invalidArguments
}

public protocol DictionaryConstructable: Codable {
    static func constructFromDict(params: Any) throws -> Self
    
}

public extension DictionaryConstructable {
    static func constructFromDict(params: Any) throws -> Self {
        guard let jsonSerialization = try? JSONSerialization.data(withJSONObject: params, options: []),
              let decoded = try? JSONDecoder().decode(Self.self, from: jsonSerialization) else {
            throw DictionaryConstructableError.invalidArguments
        }
        
        return decoded

    }
}
