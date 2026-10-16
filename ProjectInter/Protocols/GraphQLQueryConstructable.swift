//
//  GraphQLQueryConstructable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.30.
//

import Foundation
import ApolloAPI

/// Entity that can construct a GraphQL query from network arguments.
/// Query construction is static so views can build queries before handing
/// them to the network layer (see ``NetworkView``).
protocol GraphQLQueryConstructable {
    associatedtype NetworkArguments
    associatedtype GraphQLQueryType: GraphQLQuery

    static func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GraphQLQueryType
}
