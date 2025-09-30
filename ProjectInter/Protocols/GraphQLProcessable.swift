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
    func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, Error>)
}

extension GraphQLProcessable {
    func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, Error>) {
        
    }
}
