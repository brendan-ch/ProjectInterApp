//
//  NetworkStateObject.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ApolloAPI
import ApolloTestSupport
import ProjectInterOperations
import ProjectInterTestMocks

/// Represents a single system available from the server.
struct System: Equatable, Identifiable {
    var name: String
    var id: String
}

/// Represents a single stop available as part of the selected system.
struct Stop: Identifiable, Equatable {
    var name: String
    var id: String
}

/// Contains globally shared data for the app.
class GlobalDataModel: ObservableObject {
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
    
    func refreshSystemData() {
        apolloClient?.fetch(query: GetAllSystemsQuery()) { result in
            guard let data = try? result.get().data else { return }
            
            self.systems = data.systems.map { system in
                System(name: system.name, id: system.id)
            }
        }
    }
    
    func refreshStopData(systemId: String) {
        apolloClient?.fetch(query: GetAllStopsBySystemIdQuery(systemId: systemId)) { result in
            guard let data = try? result.get().data else { return }
            guard let stops = data.system?.stops else { return }
            
            self.stops = stops.map { stop in
                Stop(name: stop.name, id: stop.id)
            }
        }
    }
    
    func addPlaceholderData() {
        systems = [
            System(name: "Chapman University", id: "1"),
            System(name: "City of Monterey Park", id: "2")
        ]
    }
}
