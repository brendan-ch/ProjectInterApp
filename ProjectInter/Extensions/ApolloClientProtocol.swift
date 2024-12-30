//
//  ApolloClientProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Apollo
import ApolloAPI

extension ApolloClientProtocol {
    @discardableResult
    func fetch<Query>(query: Query, resultHandler: GraphQLResultHandler<Query.Data>?) -> (any Cancellable) where Query : GraphQLQuery {
        return fetch(query: query, cachePolicy: .default, contextIdentifier: nil, context: nil, queue: .main, resultHandler: resultHandler)
    }
}
