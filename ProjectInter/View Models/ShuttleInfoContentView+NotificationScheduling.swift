//
//  ShuttleInfoContentView+NotificationScheduling.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.11.26.
//

import Apollo
import ApolloAPI
import ProjectInterOperations

extension ShuttleInfoContentView {
    struct NotificationNetworkArguments: Hashable {
        let deviceId: String
        let shuttleId: String
        let stopId: String
        var secondsThreshold: Int?
    }

    /// Converts notification arguments into the GraphQL input object shared
    /// by the schedule and cancel mutations.
    static func generateNotificationInput(_ arguments: NotificationNetworkArguments) -> NotificationInput {
        var notificationInput = NotificationInput(
            deviceId: arguments.deviceId,
            shuttleId: arguments.shuttleId,
            stopId: arguments.stopId
        )

        if let secondsThreshold = arguments.secondsThreshold {
            notificationInput.secondsThreshold = GraphQLNullable<Int32>(integerLiteral: Int32(secondsThreshold))
        }

        return notificationInput
    }
}
