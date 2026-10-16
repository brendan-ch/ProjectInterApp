//
//  GraphQLConstructable.swift
//  ProjectInterShared
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
    associatedtype Query where Query : GraphQLQuery, Query.ResponseFormat == SingleResponseFormat

    static func create(_ query: Query, client: ApolloClient) async throws -> Self
    static func getGraphQLResult(_ query: Query, client: ApolloClient) async throws -> GraphQLResponse<Query>
}

public extension GraphQLConstructable {
    static func getGraphQLResult(_ query: Query, client: ApolloClient = ApolloClient.shared) async throws -> GraphQLResponse<Query> {
        return try await client.fetch(query: query, cachePolicy: .networkOnly)
    }
}
