//
//  ViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.31.
//

import SwiftUI
import Apollo

protocol NetworkDataModelProtocol: ObservableObject {
    associatedtype T
    
    var dataRefreshLoopTask: Task<Void, Error>? { get set }
    
    /// Starts looping a repeating task to refresh data.
    /// Waits for data to complete refreshing and waits for the specified
    /// duration. Also refreshes when first called before the sleep duration.
    ///
    /// - Parameters:
    ///   - arguments: The arguments to pass into the data refresh method.
    ///   - sleepDuration: Duration to wait after the data refresh is complete before repeating.
    func startRefreshingData(arguments: T, sleepDuration: Duration)
    
    /// Stops looping the data refresh task. An in-progress refresh or
    /// sleep timer may finish before the loop is stopped.
    func stopRefreshingData()
    
    /// Refreshes the data once and blocks the calling thread.
    /// Resumes when the refresh is done.
    func refreshDataOnce(arguments: T) async
    
    var apolloClient: ApolloClientProtocol? { get set }
    
    init(apolloClient: ApolloClientProtocol?)
}

extension NetworkDataModelProtocol {
    func startRefreshingData(arguments: T, sleepDuration: Duration = .seconds(5)) {
        if dataRefreshLoopTask != nil {
            return
        }
        
        dataRefreshLoopTask = Task {
            while !Task.isCancelled {
                await refreshDataOnce(arguments: arguments)
                try? await Task.sleep(for: sleepDuration)
            }
        }
    }
    
    func stopRefreshingData() {
        dataRefreshLoopTask?.cancel()
        dataRefreshLoopTask = nil
    }
}
