//
//  GraphQLConstructable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import Foundation
import Apollo
import ApolloAPI

/// Entity that can be fully constructed from a GraphQL resolver operation.
protocol GraphQLConstructable {
    associatedtype Query where Query : GraphQLQuery
    
    static func create(_ query: Query) async -> Self
    static func getGraphQLResult(_ query: Query) async throws -> GraphQLResult<Query.Data>
}

extension GraphQLConstructable {
    static func getGraphQLResult(_ query: Query) async throws -> GraphQLResult<Query.Data> {
        // TODO: Resolve duplicate of same code within `ApolloNetworkModel`
        return try await withCheckedThrowingContinuation { continuation in
            var continuationIsActive = true
            
            ApolloClient.shared.fetch(query: query) { result in
                defer {
                    continuationIsActive = false
                }
                
                if !continuationIsActive {
                    return
                }
                
                // ensure this is only called once
                continuation.resume(with: result)
            }
        }
    }
}
