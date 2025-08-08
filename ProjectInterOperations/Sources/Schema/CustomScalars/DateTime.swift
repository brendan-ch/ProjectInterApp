// @generated
// This file was automatically generated and can be edited to
// implement advanced custom scalar functionality.
//
// Any changes to this file will not be overwritten by future
// code generation execution.

import ApolloAPI
import Foundation

public typealias DateTime = Date

extension Date: CustomScalarType {
    public init(_jsonValue value: ApolloAPI.JSONValue) throws {
        guard let number = value as? Double else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
        }
        
        // Passed JSON data is expected to be in milliseconds
        let date = Date(timeIntervalSince1970: number / 1000)
        self = date
    }
    
    public var _jsonValue: ApolloAPI.JSONValue {
        return self.timeIntervalSince1970 * 1000
    }
}
