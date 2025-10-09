//
//  URLConstructable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation

enum URLConstructableError: Swift.Error {
    case missingUrlComponents
    case incorrectUrlHandler
    case invalidDictionaryRepresentation
}

public protocol URLConstructable: DictionaryConstructable {
    init(url: URL) throws
    static var expectedUrlPath: String { get }
}

public extension URLConstructable {
    init(url: URL) throws {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLConstructableError.missingUrlComponents
        }
        
        guard components.path == Self.expectedUrlPath else {
            throw URLConstructableError.incorrectUrlHandler
        }
        
        guard let queryItemsDict = components.queryItems?.asDictionary() else {
            throw URLConstructableError.invalidDictionaryRepresentation
        }
        
        self = try Self.constructFromDict(params: queryItemsDict)
    }
}
