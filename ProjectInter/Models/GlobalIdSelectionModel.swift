//
//  NetworkStateObject.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ProjectInterOperations

/// Contains globally selected route and shuttle IDs for the app.
class GlobalIdSelectionModel: ObservableObject {
    @Published var selectedRouteId: String? = nil
    @Published var selectedShuttleId: String? = nil
}

