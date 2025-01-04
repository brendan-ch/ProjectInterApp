//
//  NetworkStateObject.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ProjectInterOperations

// MARK: - Models

/// Represents a single system available from the server.
struct System: Equatable, Identifiable {
    var name: String
    var id: String
}


// MARK: - Network arguments

struct GlobalDataModelNetworkArguments {
    
}


// MARK: - Data model implementation

/// Contains globally shared data for the app.
class GlobalDataModel: NetworkDataModelProtocol {
    typealias T = GlobalDataModelNetworkArguments
    
    var apolloClient: ApolloClientProtocol?
    
    @Published var systems: [System] = []
    @Published var selectedSystem: System? = nil
    
    @Published var stops: [Stop] = []
    @Published var selectedStop: Stop? = nil
    
    @Published var selectedRouteId: String? = nil
    @Published var selectedShuttleId: String? = nil
    
    init(apolloClient: ApolloClientProtocol? = nil) {
        self.apolloClient = apolloClient
    }
    
    func refreshData(arguments _: GlobalDataModelNetworkArguments) {
        func refreshStopDataCallback() {
            tempImplementation_autoSelectStopId()
        }
        
        func refreshSystemDataCallback() {
            tempImplementation_autoSelectSystemId()
            
            if let id = selectedSystem?.id {
                refreshStopData(systemId: id, onSuccess: refreshStopDataCallback)
            }
        }
        
        refreshSystemData(onSuccess: refreshSystemDataCallback)
    }
    
    func refreshSystemData(onSuccess: (() -> ())? = nil) {
        apolloClient?.fetch(query: GetAllSystemsQuery()) { result in
            guard let data = try? result.get().data else { return }
            
            self.systems = data.systems.map { system in
                System(name: system.name, id: system.id)
            }
            
            if let callback = onSuccess {
                callback()
            }
        }
    }
    
    // TODO: remove once UI for selecting system is implemented
    private func tempImplementation_autoSelectSystemId() {
        if !systems.isEmpty,
           selectedSystem == nil
        {
            selectedSystem = systems[0]
        }
    }
    
    func refreshStopData(systemId: String, onSuccess: (() -> ())? = nil) {
        apolloClient?.fetch(query: GetAllStopsBySystemIdQuery(systemId: systemId)) { result in
            guard let data = try? result.get().data else { return }
            guard let stops = data.system?.stops else { return }
            
            self.stops = stops.map { stop in
                Stop(name: stop.name, id: stop.id)
            }
            
            if let callback = onSuccess {
                callback()
            }
        }
    }
    
    // TODO: replace with auto selection based on distance to user's location
    private func tempImplementation_autoSelectStopId() {
        if !stops.isEmpty,
           selectedStop == nil
        {
            selectedStop = stops[0]
        }
    }
    
    func addPlaceholderData() {
        systems = [
            System(name: "Chapman University", id: "1"),
            System(name: "City of Monterey Park", id: "2")
        ]
    }
}
