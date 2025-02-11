//
//  GlobalNotificationSchedulingModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import Foundation
import Apollo
import ProjectInterOperations

struct NotificationNetworkArguments: Hashable {
    let deviceId: String
    let shuttleId: String
    let stopId: String
}

typealias NotificationInfo = NotificationNetworkArguments

enum NotificationSchedulingFailedError: Error {
    case graphqlError
    case operationFailed
}

class GlobalNotificationSchedulingModel: ObservableObject {
    var apolloClient: ApolloClientProtocol?
    private var scheduledNotifications = Set<NotificationInfo>()
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func generateNotificationInput(_ arguments: NotificationNetworkArguments) -> NotificationInput {
        let notificationInput = NotificationInput(
            deviceId: arguments.deviceId,
            shuttleId: arguments.shuttleId,
            stopId: arguments.stopId
        )
        
        return notificationInput
    }
    func scheduleNotification(_ arguments: NotificationNetworkArguments) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            var continuationIsActive = true
            
            // TODO: Sync this state with the server once it becomes available
            defer {
                if continuationIsActive {
                    continuationIsActive = false
                    continuation.resume()
                }
            }
            
            guard let apolloClient = apolloClient else {
                return
            }
            
            if scheduledNotifications.contains(arguments) {
                return
            }
            
            let notificationInput = generateNotificationInput(arguments)
            
            apolloClient.perform(mutation: ScheduleNotificationMutation(input: notificationInput)) { result in
                if !continuationIsActive { return }
                
                guard let data = try? result.get().data else {
                    continuation.resume(throwing: NotificationSchedulingFailedError.graphqlError)
                    continuationIsActive = false
                    return
                }
                
                if !data.scheduleNotification.success {
                    continuation.resume(throwing: NotificationSchedulingFailedError.operationFailed)
                    continuationIsActive = false
                    return
                }
                
                self.scheduledNotifications.insert(arguments)
            }
            
        }
    }
    
    func cancelNotification(_ arguments: NotificationNetworkArguments) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            var continuationIsActive = true
            
            guard let apolloClient = apolloClient else {
                continuationIsActive = false
                continuation.resume()
                return
            }
            
            if scheduledNotifications.contains(arguments) {
                scheduledNotifications.remove(arguments)
            }
            
            let notificationInput = generateNotificationInput(arguments)
            
            apolloClient.perform(mutation: CancelNotificationMutation(input: notificationInput)) { result in
                if !continuationIsActive { return }
                
                guard let data = try? result.get().data else {
                    continuation.resume(throwing: NotificationSchedulingFailedError.graphqlError)
                    continuationIsActive = false
                    return
                }
                
                if !data.cancelNotification.success {
                    continuation.resume(throwing: NotificationSchedulingFailedError.operationFailed)
                    continuationIsActive = false
                    return
                }
                
                continuation.resume()
                continuationIsActive = false
            }
        }
    }
    
    func isNotificationScheduled(_ info: NotificationInfo) -> Bool {
        return scheduledNotifications.contains(info)
    }
}
