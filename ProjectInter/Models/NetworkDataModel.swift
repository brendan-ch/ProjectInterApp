//
//  NetworkDataModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.03.
//

import Apollo
import ApolloAPI

/// Base class for networking models. Subclass this class for data models/view
/// models which receive data from the server.
///
/// The models are pure reducers: updates are applied through
/// ``injectUpdate(_:)`` (see ``GraphQLProcessable``) from the networking code
/// located in the views (see ``NetworkView``). Loading state lives entirely at
/// the view layer and never passes through here.
///
/// - Warning: Override ``processRefreshDataResult(_:)`` when subclassing.
/// Otherwise, updates will be silently dropped.
class NetworkDataModel<GraphQLQueryType: GraphQLQuery>: GraphQLProcessable {
    required init() {}

    @MainActor
    func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, any Error>) {}
}
