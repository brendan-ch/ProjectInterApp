//
//  NetworkStateObject.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ProjectInterOperations

/// Contains globally selected IDs for the app.
/// For a sheet-based app, this is used for responding to notification events.
@Observable
class GlobalIdSelectionModel {
    private(set) var selectedRouteId: String? = nil {
        didSet {
            Loggers.shared.globalStateEventsLogger.log("Selected route ID changed to: \(self.selectedRouteId ?? "nil")")
        }
    }
    private(set) var selectedShuttleId: String? = nil {
        didSet {
            Loggers.shared.globalStateEventsLogger.log("Selected shuttle ID changed to: \(self.selectedShuttleId ?? "nil")")
        }
    }
    private(set) var selectedParkingStructureId: String? = nil {
        didSet {
            Loggers.shared.globalStateEventsLogger.log("Selected parking structure ID changed to: \(self.selectedParkingStructureId ?? "nil")")
        }
    }
    
    private var routeIdSyncModel: RouteIdSelectionSyncModel? = nil
    
    init(routeIdSyncModel: RouteIdSelectionSyncModel? = nil) {
        self.routeIdSyncModel = routeIdSyncModel
    }
    
    static func buildPlaceholder() -> GlobalIdSelectionModel {
        return GlobalIdSelectionModel()
    }
    
    func clearAllIds() {
        selectedRouteId = nil
        selectedShuttleId = nil
        selectedParkingStructureId = nil
    }
    
    func selectRouteId(_ id: String?) {
        clearAllIds()
        selectedRouteId = id
    }
    
    func selectShuttleIdIfRouteIdSelected(_ id: String?) {
        guard selectedRouteId != nil else { return }
        
        selectedParkingStructureId = nil
        selectedShuttleId = id
    }
    
    func autoSelectRouteIdFromShuttleId(_ arguments: RouteIdSelectionSyncNetworkArguments) async {
        guard let routeIdSyncModel = routeIdSyncModel else { return }
        
        await routeIdSyncModel.refreshDataOnce(arguments: arguments)
        selectedRouteId = routeIdSyncModel.routeId
        selectedShuttleId = arguments.shuttleId
    }
    
    func selectParkingStructureId(_ id: String?) {
        clearAllIds()
        selectedParkingStructureId = id
    }
}

