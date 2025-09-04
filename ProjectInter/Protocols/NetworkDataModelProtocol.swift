//
//  ViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.31.
//

import SwiftUI
import Apollo
import ApolloAPI

enum InitializationState {
    case notInitialized
    case initializing
    case succeeded
    case failed
}

/// Protocol for network models which receive data from the server.
/// To create a class which implements this, subclass ``NetworkDataModel``.
protocol NetworkDataModelProtocol: AnyObject {
    associatedtype NetworkArguments
    associatedtype GraphQLQueryType: GraphQLQuery
    
    /// Starts looping a repeating task to refresh data.
    /// Waits for data to complete refreshing and waits for the specified
    /// duration. Also refreshes when first called before the sleep duration.
    ///
    /// - Parameters:
    ///   - arguments: The arguments to pass into the data refresh method.
    ///   - sleepDuration: Duration to wait after the data refresh is complete before repeating.
    func startRefreshingData(arguments: NetworkArguments, sleepDuration: Duration)
    
    /// Stops looping the data refresh task. An in-progress refresh or
    /// sleep timer may finish before the loop is stopped.
    func stopRefreshingData()
    
    /// Refreshes the data once and blocks the calling thread.
    /// Resumes when the refresh is done.
    func refreshDataOnce(arguments: NetworkArguments) async
    
    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GraphQLQueryType?
    
    @MainActor
    func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, Error>)

    var apolloNetworkModel: ApolloNetworkModel? { get set }
    
    init(apolloNetworkModel: ApolloNetworkModel?)
    init(dataInitState: InitializationState)
}

extension NetworkDataModelProtocol {
}
