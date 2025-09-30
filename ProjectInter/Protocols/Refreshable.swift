//
//  Refreshable.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.30.
//

import Foundation

protocol Refreshable: AnyObject {
    associatedtype NetworkArguments
    
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
}
