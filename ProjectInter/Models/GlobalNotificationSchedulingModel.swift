//
//  GlobalNotificationSchedulingModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import Foundation
import Apollo
import ProjectInterOperations

struct NotificationNetworkArguments {
    let deviceId: String
    let shuttleId: String
    let stopId: String
}

enum NotificationSchedulingFailedError: Error {
    case operationFailed
}

class GlobalNotificationSchedulingModel {
    var apolloClient: ApolloClientProtocol?
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func scheduleNotification(_ arguments: NotificationNetworkArguments) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            var continuationIsActive = true
            
            guard let apolloClient = apolloClient else {
                continuationIsActive = false
                continuation.resume()
                return
            }
            
            continuation.resume(throwing: NotificationSchedulingFailedError.operationFailed)
        }
    }
    
    func removeNotification(_ arguments: NotificationNetworkArguments) async throws {
        
    }
}
