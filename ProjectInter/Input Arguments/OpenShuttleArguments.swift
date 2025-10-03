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
struct OpenShuttleArguments: URLConstructable, UNNotificationConstructable, Equatable {
    let shuttleId: String
    let systemId: String
    let stopId: String
}

extension OpenShuttleArguments {
    static var expectedUrlPath: String { "/openShuttle" }
}
