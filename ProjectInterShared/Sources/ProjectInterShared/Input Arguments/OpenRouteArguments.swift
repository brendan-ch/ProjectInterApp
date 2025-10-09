//
//  OpenRouteArguments.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

import Foundation

/// Arguments needed for the app to open a route, say,
/// from a URL or notification.
public struct OpenRouteArguments: URLConstructable, Equatable {
    public let routeId: String
    public let systemId: String
    public let stopId: String
}

public extension OpenRouteArguments {
    static var expectedUrlPath: String { "/openRoute" }
}
