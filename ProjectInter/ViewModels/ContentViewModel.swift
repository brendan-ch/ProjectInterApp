//
//  ContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.24.
//

import SwiftUI
import Apollo
import ProjectInterOperations

// MARK: - Data models generated from GraphQL fragments

struct Coordinates: Equatable {
    var latitude: Double
    var longitude: Double
}

struct ContentViewShuttle: Equatable, Identifiable {
    var coordinates: Coordinates
    var routeColorHex: String
    var id: String
}

struct ContentViewStop: Equatable, Identifiable {
    var id: String
    var name: String
}

struct ContentViewRoute: Equatable, Identifiable {
    var id: String
    var name: String
    var colorHex: String
    var nextStopName: String
    var etaDisplayString: String
}

// MARK: - ContentViewModel definition and implementation

protocol ContentViewModelProtocol: ObservableObject {
    var shuttles: [ContentViewShuttle] { get set }
    var stops: [ContentViewStop] { get set }
    var routes: [ContentViewRoute] { get set }
    
    var currentlySelectedStop: ContentViewStop? { get set }
}

class ContentViewModel: ContentViewModelProtocol {
    @Published var shuttles: [ContentViewShuttle] = []
    @Published var stops: [ContentViewStop] = []
    @Published var routes: [ContentViewRoute] = []
    
    @Published var currentlySelectedStop: ContentViewStop? = nil
    
    private var apolloClient: ApolloClient
    
    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
    
    func refreshStopData(systemId: String) {
        apolloClient.fetch(query: GetAllStopsBySystemIdQuery(systemId: systemId)) { result in
            guard let data = try? result.get().data else { return }
            
            self.stops = data.system?.stops?.map { stop in
                ContentViewStop(id: stop.id, name: stop.name)
            } ?? []
        }
    }
    
    func refreshAllData(systemId: String, stopId: String) {
        
    }
}

class PlaceholderContentViewModel: ContentViewModelProtocol {
    @Published var shuttles: [ContentViewShuttle] = []
    @Published var stops: [ContentViewStop] = []
    @Published var routes: [ContentViewRoute] = []
    
    @Published var currentlySelectedStop: ContentViewStop? = nil
}
