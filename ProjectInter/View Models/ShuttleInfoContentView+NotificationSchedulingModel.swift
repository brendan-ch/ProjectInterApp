//
//  ShuttleInfoContentView+NotificationSchedulingModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.11.26.
//

import SwiftUI
import Apollo
import ProjectInterOperations
import ProjectInterLogging

extension ShuttleInfoContentView {
    struct NotificationNetworkArguments: Hashable {
        let deviceId: String
        let shuttleId: String
        let stopId: String
        var secondsThreshold: Int?
    }
    
    typealias NotificationInfo = NotificationNetworkArguments
    
    enum NotificationSchedulingFailedError: Error {
        case graphqlError
        case operationFailed
    }
    
    /// Model for handling shuttle notifications.
    /// Only contains logic pertaining to shuttle notifications, and should only
    /// be consumed by views related to shuttle notification scheduling.
    @Observable
    class NotificationSchedulingModel {
        var apolloClient: ApolloClientProtocol?
        
        init(apolloClient: ApolloClientProtocol? = nil) {
            self.apolloClient = apolloClient
        }
        
        func generateNotificationInput(_ arguments: NotificationNetworkArguments) -> NotificationInput {
            var notificationInput = NotificationInput(
                deviceId: arguments.deviceId,
                shuttleId: arguments.shuttleId,
                stopId: arguments.stopId
            )
            
            if let secondsThreshold = arguments.secondsThreshold {
                notificationInput.secondsThreshold = GraphQLNullable<Int>(integerLiteral: secondsThreshold)
            }
            
            return notificationInput
        }
        
        func scheduleNotification(_ arguments: NotificationNetworkArguments) async throws {
            let stopId = arguments.stopId
            let shuttleId = arguments.shuttleId
            
            let loggingString = "(stopId: \(stopId), shuttleId: \(shuttleId))"
            
            guard let apolloClient = apolloClient else {
                Loggers.shared.networkingLogger.warning("No Apollo client provided for \(type(of: self)); skipping notification schedule for \(loggingString)")
                return
            }
            
            Loggers.shared.networkingLogger.notice("Starting notification schedule for \(loggingString)")
            return try await withCheckedThrowingContinuation { continuation in
                var continuationIsActive = true
                
                let notificationInput = generateNotificationInput(arguments)
                
                apolloClient.perform(mutation: ScheduleNotificationMutation(input: notificationInput)) { result in
                    if !continuationIsActive { return }
                    
                    guard let data = try? result.get().data else {
                        Loggers.shared.networkingLogger.error("Unable to get response when scheduling notification for \(loggingString)")
                        continuation.resume(throwing: NotificationSchedulingFailedError.graphqlError)
                        continuationIsActive = false
                        return
                    }
                    
                    if !data.scheduleNotification.success {
                        Loggers.shared.networkingLogger.error("Server returned error when scheduling notification for \(loggingString)")
                        continuation.resume(throwing: NotificationSchedulingFailedError.operationFailed)
                        continuationIsActive = false
                        return
                    }
                    
                    Loggers.shared.networkingLogger.notice("Notification scheduled for \(loggingString)")
                    continuationIsActive = false
                    continuation.resume()
                }
                
            }
        }
        
        func cancelNotification(_ arguments: NotificationNetworkArguments) async throws {
            let stopId = arguments.stopId
            let shuttleId = arguments.shuttleId
            
            let loggingString = "(stopId: \(stopId), shuttleId: \(shuttleId))"
            
            guard let apolloClient = apolloClient else {
                Loggers.shared.networkingLogger.warning("No Apollo client provided for \(type(of: self)); skipping notification cancel for \(loggingString)")
                return
            }
            
            Loggers.shared.networkingLogger.notice("Starting notification cancel for \(loggingString)")
            return try await withCheckedThrowingContinuation { continuation in
                var continuationIsActive = true
                
                let notificationInput = generateNotificationInput(arguments)
                
                apolloClient.perform(mutation: CancelNotificationMutation(input: notificationInput)) { result in
                    if !continuationIsActive { return }
                    
                    guard let data = try? result.get().data else {
                        Loggers.shared.networkingLogger.error("Unable to get response when cancelling notification for \(loggingString)")
                        continuation.resume(throwing: NotificationSchedulingFailedError.graphqlError)
                        continuationIsActive = false
                        return
                    }
                    
                    if !data.cancelNotification.success {
                        Loggers.shared.networkingLogger.error("Server returned error when cancelling notification for \(loggingString)")
                        continuation.resume(throwing: NotificationSchedulingFailedError.operationFailed)
                        continuationIsActive = false
                        return
                    }
                    
                    Loggers.shared.networkingLogger.notice("Notification cancelled for \(loggingString)")
                    continuation.resume()
                    continuationIsActive = false
                }
            }
        }
    }

}
