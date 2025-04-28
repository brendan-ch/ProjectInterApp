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
    @Published var selectedRouteId: String? = nil {
        didSet {
            Loggers.shared.globalStateEventsLogger.log("Selected route ID changed to: \(self.selectedRouteId ?? "nil")")
        }
    }
    @Published var selectedShuttleId: String? = nil {
        didSet {
            Loggers.shared.globalStateEventsLogger.log("Selected shuttle ID changed to: \(self.selectedShuttleId ?? "nil")")
        }
    }
}

