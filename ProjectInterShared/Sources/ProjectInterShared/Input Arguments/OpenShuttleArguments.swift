//
//  OpenShuttleArguments.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation
import UserNotifications

/// Arguments needed for the app to open a shuttle, say,
/// from a URL or notification.
public struct OpenShuttleArguments: URLConstructable, UNNotificationConstructable, Equatable {
    public let shuttleId: String
    public let systemId: String
    public let stopId: String
}

public extension OpenShuttleArguments {
    static var expectedUrlPath: String { "/openShuttle" }
}
