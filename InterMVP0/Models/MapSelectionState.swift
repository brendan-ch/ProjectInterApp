//
//  MapSelectionState.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.18.
//

import SwiftUI
import MapKit

class MapSelectionState: ObservableObject {
    @Published var selectedRoute: MockRoute?
    @Published var selectedShuttle: Shuttle?
    
    var routeToDisplay: MockRoute? {
        if selectedRoute != nil {
            return selectedRoute
        } else if selectedShuttle != nil {
            return selectedShuttle?.route ?? nil
        }
        return nil
    }
    
    var coordinatesToDisplayForPolyline: [CLLocationCoordinate2D]? {
        var routeToDisplay = selectedRoute
        if routeToDisplay == nil {
            routeToDisplay = selectedShuttle?.route
        }
        
        guard let routeToDisplay = routeToDisplay else { return nil }
        
        let coordinates = routeToDisplay.coordinates
        
        var coordinatesToReturn: [CLLocationCoordinate2D] = []
        for coordinate in coordinates {
            coordinatesToReturn.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        return coordinatesToReturn
    }
    
}
