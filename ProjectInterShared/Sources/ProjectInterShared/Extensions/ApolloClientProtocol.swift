//
//  ApolloClientExtensions.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Apollo
import ApolloAPI

public extension ApolloClient {
    @discardableResult
    func fetch<Query>(query: Query, resultHandler: GraphQLResultHandler<Query>?) -> (any Cancellable) where Query : GraphQLQuery {
        return fetch(
            query: query,
            cachePolicy: CachePolicy_v1.fetchIgnoringCacheData,
            context: nil,
            queue: .main,
            resultHandler: resultHandler
        )
    }

    @discardableResult
    func perform<Mutation>(mutation: Mutation, resultHandler: GraphQLResultHandler<Mutation>?) -> (any Cancellable) where Mutation : GraphQLMutation {
        return perform(
            mutation: mutation,
            publishResultToStore: false,
            queue: .main,
            resultHandler: resultHandler
        )
    }
}
