//
//  ViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.31.
//

import SwiftUI
import Apollo
import ApolloAPI


protocol GraphQLQueryable: Refreshable, GraphQLProcessable, GraphQLQueryConvertible {
    var apolloNetworkModel: ApolloNetworkModel? { get set }
    
    init(apolloNetworkModel: ApolloNetworkModel?)
}

