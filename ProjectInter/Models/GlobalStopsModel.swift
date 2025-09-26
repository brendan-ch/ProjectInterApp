//
//  GlobalStopsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.03.
//

import SwiftUI
import Apollo
import ProjectInterOperations
import MapKit

// MARK: - Models

struct GlobalStopsNetworkArguments {
    let systemId: String
}

/// Represents a single stop available as part of the selected system.
struct GlobalStopsModelStop: Identifiable, Equatable {
    var name: String
    var id: String
    var coordinates: RawCoordinates
    var routeIds: Set<String> = []
}

extension GlobalStopsModelStop {
    init(_ stop: GetAllStopsBySystemIdQuery.Data.System.Stop) {
        self.coordinates = RawCoordinates(latitude: stop.coordinates.latitude, longitude: stop.coordinates.longitude)
        
        self.name = stop.name
        self.id = stop.id
        
        guard let orderedStops = stop.orderedStops else { return }
        for orderedStop in orderedStops {
            self.routeIds.insert(orderedStop.routeId)
        }
    }
}

// MARK: - Data model implementation

@Observable
class GlobalStopsModel: NetworkDataModel<GlobalStopsNetworkArguments, GetAllStopsBySystemIdQuery>, PlaceholderBuildable {
    
    var apolloClient: ApolloClientProtocol?
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var stops: [GlobalStopsModelStop] = []
    
    private var selectedStopId: String? = nil {
        didSet {
            Loggers.shared.globalStateEventsLogger.notice("Selected stop ID changed to: \(self.selectedStopId ?? "nil")")
        }
    }
    var selectedStop: GlobalStopsModelStop? {
        stops.first { $0.id == selectedStopId }
    }
    
    var selectedStopIdOnMap: String? = nil
    
    /// Indicates whether the stop has been manually selected by the user.
    /// Consumers of this class should take this into account when determining
    /// whether to automatically select a stop.
    private(set) var stopSelectionManuallyOverridenByUser: Bool = false
    
    override func convertNetworkArgumentsIntoQuery(_ arguments: GlobalStopsNetworkArguments) -> GetAllStopsBySystemIdQuery? {
        return GetAllStopsBySystemIdQuery(systemId: arguments.systemId)
    }
    
    override func processRefreshDataResult(_ result: Result<GetAllStopsBySystemIdQuery.Data, any Error>) {
        guard let data = try? result.get() else {
            return
        }
        guard let stops = data.system?.stops else {
            return
        }
        
        self.stops = stops.map(GlobalStopsModelStop.init)
        self.stops.sort { $0.name < $1.name }
    }
    
    func selectStopId(_ stopId: String) {
        selectedStopId = stopId
        stopSelectionManuallyOverridenByUser = true
    }
    
    /// Automatically select a stop, either based on the passed location, or by selecting
    /// the first available stop.
    func automaticallySelectStop(for location: CLLocationCoordinate2D? = nil) {
        if let location = location {
            selectClosestStopBasedOnLocation(location: location)
        } else {
            selectedStopId = stops.first?.id
        }
        stopSelectionManuallyOverridenByUser = false
    }
    
    /// From the currently saved stops, select the one that is closest to the provided location.
    private func selectClosestStopBasedOnLocation(location: CLLocationCoordinate2D) {
        guard var closest = stops.first else {
            Loggers.shared.globalStateEventsLogger.warning("Attempted to select stop based on location, but no stops available")
            
            return
        }
        Loggers.shared.globalStateEventsLogger.notice("Selecting stop based on location")
        
        for savedStop in stops {
            let stopLocation = savedStop.coordinates.asCLLocationCoordinate2D
            let locationOfCurrentClosestStop = closest.coordinates.asCLLocationCoordinate2D
            
            let distanceForCurrentStopInIteration = calculateDistance(location, stopLocation)
            let distanceForCurrentClosestStop = calculateDistance(location, locationOfCurrentClosestStop)
            
            if distanceForCurrentClosestStop > distanceForCurrentStopInIteration {
                closest = savedStop
            }
        }
        
        selectedStopId = closest.id
    }
    
    private func calculateDistance(_ location1: CLLocationCoordinate2D, _ location2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let location2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        
        return location1.distance(from: location2)
    }
    
    static func buildPlaceholder() -> Self {
        let newModel = Self(dataInitState: .succeeded)
        newModel.stops = [
            GlobalStopsModelStop(name: "Chapman Court", id: "1", coordinates: RawCoordinates(latitude: 33.796796, longitude: -117.889293)),
            GlobalStopsModelStop(name: "Schmid Gate", id: "2", coordinates: RawCoordinates(latitude: 33.793292, longitude: -117.852904))
        ]
        newModel.selectStopId(newModel.stops.first!.id)
        
        return newModel
    }
}

