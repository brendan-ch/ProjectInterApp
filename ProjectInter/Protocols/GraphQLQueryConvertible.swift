//
//  GraphQLQueryConvertible.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.30.
//

import Foundation
import ApolloAPI

protocol GraphQLQueryConvertible: Refreshable {
    associatedtype GraphQLQueryType: GraphQLQuery

    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GraphQLQueryType?
}

extension GraphQLQueryConvertible {
    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GraphQLQueryType? {
        return nil
    }
}
