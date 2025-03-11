//
//  MapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.10.
//

import SwiftUI
import MapKit

class MapViewPreviousSelectionState {
    var previousSystem: System?
    var previousRouteId: String?
    var previousShuttleId: String?
}

// MARK: - UIViewRepresentable
struct MapViewRepresentable: UIViewRepresentable {
    @EnvironmentObject var globalDataState: GlobalDataModel
    @EnvironmentObject var globalStopsModel: GlobalStopsModel
    @EnvironmentObject var viewModel: MapViewModel
//    @ObservedObject var viewModel = MapViewModel()
    
    var previousSelectionState = MapViewPreviousSelectionState()
    
    // Track changes for data updates and map positioning
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateRoutePolyline(uiView, context: context)
        updateAnnotations(uiView, context: context)
        updatePositioning(uiView, context: context)
    }
    
    private func updateRoutePolyline(_ uiView: MKMapView, context: Context) {
        // Update polylines
        uiView.removeOverlays(uiView.overlays)
        
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
    }
    
    private func updateAnnotations(_ uiView: MKMapView, context: Context) {
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
                
                if let selectedStop = globalStopsModel.selectedStop,
                   selectedStop.id == stop.id {
                    annotation.shouldShowTitle = true
                }
                
                uiView.addAnnotation(annotation)
            }
        } else if let selectedStop = globalStopsModel.selectedStop,
                  let stopToRender = viewModel.stops.first(where: { $0.id == selectedStop.id }) {
            let annotation = StopAnnotation(stop: stopToRender)
            annotation.shouldShowTitle = true
            uiView.addAnnotation(annotation)
        }
    }
    
    private func updatePositioning(_ uiView: MKMapView, context: Context) {
        // Handle position changes
        if viewModel.position == .automatic {
            // Get all the points in the map view
            var points: [CLLocationCoordinate2D] = []
            points.append(contentsOf: uiView.annotations.map { $0.coordinate })
            
            if let polyline = uiView.overlays.first as? MKPolyline {
                var polylinePoints = Array(repeating: CLLocationCoordinate2D(), count: polyline.pointCount)
                polyline.getCoordinates(&polylinePoints, range: NSRange(location: 0, length: polyline.pointCount))
                points.append(contentsOf: polylinePoints)
            }
            
            if !points.isEmpty {
                let rect = points.reduce(MKMapRect.null) { rect, point in
                    let pointRect = MKMapRect(origin: MKMapPoint(point), size: MKMapSize(width: 0, height: 0))
                    return rect.union(pointRect)
                }
                
                var region = MKCoordinateRegion(rect)
                region = MKCoordinateRegion(
                    center: region.center,
                    span: MKCoordinateSpan(
                        latitudeDelta: region.span.latitudeDelta * 1.4,
                        longitudeDelta: region.span.longitudeDelta * 1.4
                    )
                )
                
                uiView.setRegion(region, animated: true)
            }
        }
    }
}

// MARK: - Coordinator class
class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapViewRepresentable
    
    init(_ parent: MapViewRepresentable) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? ShuttleAnnotation {
            // TODO: Do stuff.
            print(parent.viewModel.stops)
            print(annotation.shuttle.id)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            if view.annotation is ShuttleAnnotation {
                view.superview?.bringSubviewToFront(view)
            } else {
                view.superview?.sendSubviewToBack(view)
            }
        }
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
        case is ShuttleAnnotation:
            return ShuttleAnnotationView(annotation: annotation, reuseIdentifier: "shuttle")
        case is StopAnnotation:
            return StopAnnotationView(annotation: annotation, reuseIdentifier: "stop")
        default:
            return nil
        }
    }
}

// MARK: - Map polyline subclass to hold associated route data
class RoutePolyline: MKPolyline {
    var route: MapViewRoute?
}
