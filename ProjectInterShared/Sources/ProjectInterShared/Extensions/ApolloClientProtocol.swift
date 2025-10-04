//
//  ApolloClientProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Apollo
import ApolloAPI

public extension ApolloClientProtocol {
    @discardableResult
    func fetch<Query>(query: Query, resultHandler: GraphQLResultHandler<Query.Data>?) -> (any Cancellable) where Query : GraphQLQuery {
        return fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
            contextIdentifier: nil,
            context: nil,
            queue: .main,
            resultHandler: resultHandler
        )
    }
    
    @discardableResult
    func perform<Mutation>(mutation: Mutation, resultHandler: GraphQLResultHandler<Mutation.Data>?) -> (any Cancellable) where Mutation : GraphQLMutation {
        return perform(
            mutation: mutation,
            publishResultToStore: false,
            contextIdentifier: nil,
            context: nil,
            queue: .main,
            resultHandler: resultHandler
        )
    }
}
