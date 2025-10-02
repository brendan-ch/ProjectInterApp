//
//  OpenRouteArguments.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

/// Arguments needed for the app to open a route, say,
/// from a URL or notification.
struct OpenRouteArguments: Codable, Equatable {
    let routeId: String
    let systemId: String
    let stopId: String
}
