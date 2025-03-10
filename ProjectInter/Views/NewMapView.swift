//
//  NewMapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.10.
//

import SwiftUI
import MapKit

class NewMapViewPreviousSelectionState {
    var previousSystem: System?
    var previousRouteId: String?
    var previousShuttleId: String?
}

// MARK: - UIViewRepresentable
struct NewMapView: UIViewRepresentable {
    @EnvironmentObject var globalDataState: GlobalDataModel
    @EnvironmentObject var globalStopsModel: GlobalStopsModel
    @ObservedObject var viewModel = MapViewModel()
    
    var previousSelectionState = NewMapViewPreviousSelectionState()
    
    // Track changes for data updates and map positioning
    
    func makeCoordinator() -> NewMapViewCoordinator {
        NewMapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        checkForStateChangesToRestartDataUpdates()
        
        // Update polylines
        uiView.removeOverlays(uiView.overlays)
        
        // MARK: Route polyline
        if let routeId = globalDataState.selectedRouteId {
            let routeToDisplay = viewModel.routes.first { route in
                route.id == routeId
            }
            
            if let routeToDisplay = routeToDisplay {
                let polyline = RoutePolyline(coordinates: routeToDisplay.polylineCoordinates,
                    count: routeToDisplay.polylineCoordinates.count
                )
                polyline.route = routeToDisplay
                
                uiView.addOverlay(polyline)
            }

        }
        
        // MARK: Annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Add shuttle annotations
        for shuttle in viewModel.shuttles {
            let associatedStopForSelectedStop = viewModel.stops.first { stop in
                stop.id == globalStopsModel.selectedStop?.id
            }
            let shouldDisplayShuttle =
            (globalDataState.selectedRouteId != nil && shuttle.routeId == globalDataState.selectedRouteId)
            ||
            (globalDataState.selectedRouteId == nil && associatedStopForSelectedStop != nil
             && associatedStopForSelectedStop!.routeIds.contains(shuttle.routeId ?? ""))
            
            if shouldDisplayShuttle {
                let annotation = ShuttleAnnotation(shuttle: shuttle)
                uiView.addAnnotation(annotation)
            }
        }
        
        // Add stop annotations
        if let routeId = globalDataState.selectedRouteId {
            for stop in viewModel.stops where stop.routeIds.contains(routeId) {
                let annotation = StopAnnotation(stop: stop)
                uiView.addAnnotation(annotation)
            }
        } else if let selectedStop = globalStopsModel.selectedStop,
                  let stopToRender = viewModel.stops.first(where: { $0.id == selectedStop.id }) {
            let annotation = StopAnnotation(stop: stopToRender)
            uiView.addAnnotation(annotation)
        }
        
        // Handle position changes
        //        if viewModel.position == .automatic {
        //            // Calculate the region that encompasses all visible annotations
        //            var points: [CLLocationCoordinate2D] = []
        //            points.append(contentsOf: uiView.annotations.map { $0.coordinate })
        //            if let polyline = uiView.overlays.first as? MKPolyline {
        //                points.append(contentsOf: polyline.coordinates)
        //            }
        //
        //            if !points.isEmpty {
        //                let region = MKCoordinateRegion(coordinates: points)
        //                uiView.setRegion(region, animated: true)
        //            }
        //        }
    }
}

// MARK: - Networking extension for map view
extension NewMapView {
    var mapViewNetworkArguments: MapViewNetworkArguments? {
        guard let systemId = globalDataState.selectedSystem?.id else { return nil }
        
        return MapViewNetworkArguments(systemId: systemId)
    }
    
    private func checkForStateChangesToRestartDataUpdates() {
        guard let client = globalDataState.apolloClient else {
            return
        }
        
        viewModel.apolloClient = client
        
        guard let selectedSystem = globalDataState.selectedSystem else {
            return
        }

        if previousSelectionState.previousSystem != selectedSystem {
            restartDataUpdatesIfArgumentsExist()
            
            previousSelectionState.previousSystem = selectedSystem
        }
    }
    
    private func restartDataUpdatesIfArgumentsExist() {
        if let arguments = mapViewNetworkArguments {
            viewModel.stopRefreshingData()
            viewModel.startRefreshingData(arguments: arguments)
        }
    }
}
    
// MARK: - Coordinator class
class NewMapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: NewMapView
    
    init(_ parent: NewMapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? RoutePolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if let routeId = parent.globalDataState.selectedRouteId,
               let route = polyline.route {
                renderer.strokeColor = UIColor(hex: route.colorHex)
                renderer.lineWidth = 5
            }
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
//        case is ShuttleAnnotation:
//            return ShuttleAnnotationView(annotation: annotation, reuseIdentifier: "shuttle")
//        case is StopAnnotation:
//            return StopAnnotationView(annotation: annotation, reuseIdentifier: "stop")
        default:
            return nil
        }
    }
}

// MARK: - Map polyline subclass to hold associated route data
class RoutePolyline: MKPolyline {
    var route: MapViewRoute?
}

// MARK: - Map annotation objects
class ShuttleAnnotation: NSObject, MKAnnotation {
    let shuttle: MapViewShuttle
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(shuttle: MapViewShuttle) {
        self.shuttle = shuttle
        self.coordinate = shuttle.coordinates
        self.title = shuttle.name
        super.init()
    }
}

class StopAnnotation: NSObject, MKAnnotation {
    let stop: MapViewStop
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(stop: MapViewStop) {
        self.stop = stop
        self.coordinate = stop.coordinates
        self.title = stop.name
        super.init()
    }
}
