//
//  GraphQLConstructable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.03.
//

import Foundation
import Apollo
import ApolloAPI

public enum GraphQLConstructableError: Swift.Error {
    case dataNotAvailable
}

/// Entity that can be fully constructed from a GraphQL resolver operation.
public protocol GraphQLConstructable {
    associatedtype Query where Query : GraphQLQuery
    
    static func create(_ query: Query, client: ApolloClient) async throws -> Self
    static func getGraphQLResult(_ query: Query, client: ApolloClient) async throws -> GraphQLResponse<Query>
}

public extension GraphQLConstructable {
    static func getGraphQLResult(_ query: Query, client: ApolloClient = ApolloClient.shared) async throws -> GraphQLResponse<Query> {
        // TODO: Resolve duplicate of same code within `ApolloNetworkModel`
        return try await withCheckedThrowingContinuation { continuation in
            var continuationIsActive = true
            
            client.fetch(query: query) { result in
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
