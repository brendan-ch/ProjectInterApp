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

protocol NetworkDataModelProtocol: ObservableObject {
    associatedtype NetworkArguments
    associatedtype GraphQLQueryType: GraphQLQuery
    
    var dataInitState: InitializationState { get set }
    
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
    
    @MainActor
    func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, Error>)

    var apolloNetworkModel: ApolloNetworkModel? { get set }
    
    init(apolloNetworkModel: ApolloNetworkModel?)
}

extension NetworkDataModelProtocol where Self: Sendable {
    @MainActor
    private func setDataInitState(_ newState: InitializationState) {
        if newState == .initializing && (dataInitState == .notInitialized || dataInitState == .failed) {
            self.dataInitState = newState
        } else if (newState == .succeeded || newState == .failed) && dataInitState == .initializing {
            self.dataInitState = newState
        }
    }
    
    func startRefreshingData(arguments: NetworkArguments, sleepDuration: Duration = .seconds(5)) {
        if dataRefreshLoopTask != nil {
            Loggers.shared.networkingLogger.warning("Data refresh already active for \(type(of: self))")
            return
        }

        Loggers.shared.networkingLogger.notice("Starting data refresh for \(type(of: self))")
        
        let query = convertNetworkArgumentsIntoQuery(arguments)
        dataRefreshLoopTask = Task {
            await setDataInitState(.initializing)
            guard let stream = apolloNetworkModel?.getStream(query, sleepDuration: sleepDuration) else {
                return
            }
            
            for try await result in stream {
                switch result {
                case .failure:
                    await setDataInitState(.failed)
                case .success:
                    await setDataInitState(.succeeded)
                }
                
                await processRefreshDataResult(result)
            }
        }
    }
    
    func stopRefreshingData() {
        Loggers.shared.networkingLogger.notice("Stopping data refresh for \(type(of: self))")
        dataRefreshLoopTask?.cancel()
        dataRefreshLoopTask = nil
    }
    
    func refreshDataOnce(arguments: NetworkArguments) async {
        await setDataInitState(.initializing)
        // Spawn a one-off task to refresh the data
        let query = convertNetworkArgumentsIntoQuery(arguments)
        guard let apolloNetworkModel = apolloNetworkModel else {
            await setDataInitState(.failed)
            Loggers.shared.networkingLogger.warning("No network model provided for \(type(of: self)); skipping data refresh")
            return
        }
        Loggers.shared.networkingLogger.notice("Refreshing data for \(type(of: self))")
        do {
            let result = try await apolloNetworkModel.fetchOnce(query)
            if let data = result.data {
                await setDataInitState(.succeeded)
                await processRefreshDataResult(.success(data))
            }
        } catch {
            await setDataInitState(.failed)
            await processRefreshDataResult(.failure(error))
        }
    }
}
