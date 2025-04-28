//
//  ViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.31.
//

import SwiftUI
import Apollo
import ApolloAPI

protocol NetworkDataModelProtocol: ObservableObject {
    associatedtype NetworkArguments
    associatedtype GraphQLQueryType: GraphQLQuery
    
    var dataRefreshLoopTask: Task<Void, Error>? { get set }
    
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
    
    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GraphQLQueryType
    func processRefreshDataResult(_ result: Result<GraphQLResult<GraphQLQueryType.Data>, Error>)
    
    var apolloClient: ApolloClientProtocol? { get set }
}

extension NetworkDataModelProtocol {
    func startRefreshingData(arguments: NetworkArguments, sleepDuration: Duration = .seconds(5)) {
        if dataRefreshLoopTask != nil {
            LoggerHolderSingleton.shared.networkingLogger.warning("Data refresh already active for \(type(of: self))")
            return
        }
        
        LoggerHolderSingleton.shared.networkingLogger.notice("Starting data refresh for \(type(of: self))")
        dataRefreshLoopTask = Task {
            while !Task.isCancelled {
                await refreshDataOnce(arguments: arguments)
                try? await Task.sleep(for: sleepDuration)
            }
        }
    }
    
    func stopRefreshingData() {
        LoggerHolderSingleton.shared.networkingLogger.notice("Stopping data refresh for \(type(of: self))")
        dataRefreshLoopTask?.cancel()
        dataRefreshLoopTask = nil
    }
    
    func refreshDataOnce(arguments: NetworkArguments) async {
        let query = convertNetworkArgumentsIntoQuery(arguments)
        
        guard let apolloClient = apolloClient else {
            LoggerHolderSingleton.shared.networkingLogger.warning("No Apollo client provided for \(type(of: self)); skipping data refresh")
            return
        }

        LoggerHolderSingleton.shared.networkingLogger.notice("Refreshing data for \(type(of: self))")

        return await withCheckedContinuation { continuation in
            var continuationIsActive = true
            
            apolloClient.fetch(query: query) { result in
                defer {
                    continuationIsActive = false
                    continuation.resume()
                }
                
                if !continuationIsActive {
                    return
                }
                
                LoggerHolderSingleton.shared.stateEventsLogger.notice("Processing refresh data result for \(type(of: self))")
                self.processRefreshDataResult(result)
            }
        }
    }
}
