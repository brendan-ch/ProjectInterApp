//
//  GraphQLProcessable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.30.
//

import Foundation
import ApolloAPI

protocol GraphQLProcessable: AnyObject {
    associatedtype GraphQLQueryType: GraphQLQuery

    @MainActor
    func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, any Error>)
}

extension GraphQLProcessable {
    func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, any Error>) {

    }

    /// Applies a result produced by network code (a polling stream iteration
    /// or a one-off fetch) by routing it to ``processRefreshDataResult(_:)``.
    @MainActor
    func injectUpdate(_ result: Result<GraphQLQueryType.Data, any Error>) {
        processRefreshDataResult(result)
    }
}
