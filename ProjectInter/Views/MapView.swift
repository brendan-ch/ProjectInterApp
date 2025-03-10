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
struct MapView: UIViewRepresentable {
    @EnvironmentObject var globalDataState: GlobalDataModel
    @EnvironmentObject var globalStopsModel: GlobalStopsModel
    @ObservedObject var viewModel = MapViewModel()
    
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

// MARK: - Networking extension for map view
extension MapView {
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
class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
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
        case is ShuttleAnnotation:
            return ShuttleAnnotationView(annotation: annotation, reuseIdentifier: "shuttle")
        case is StopAnnotation:
            return StopAnnotationView(annotation: annotation, reuseIdentifier: "stop")
        default:
            return nil
        }
    }
}

// MARK: - Annotation views
class StopAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        let circleView = UIView(frame: bounds)
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = bounds.width / 2
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.black.cgColor
        
        addSubview(circleView)
    }
}

class ShuttleAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        guard let shuttleAnnotation = annotation as? ShuttleAnnotation else { return }
        
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = UIColor(hex: shuttleAnnotation.shuttle.routeColorHex ?? "#000000")
        backgroundView.layer.cornerRadius = bounds.width / 2
        backgroundView.layer.borderWidth = 4
        backgroundView.layer.borderColor = UIColor.white.cgColor
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16)
        let busImage = UIImageView(image: UIImage(systemName: "bus.fill", withConfiguration: imageConfig))
        busImage.tintColor = .white
        busImage.frame = bounds.insetBy(dx: 6, dy: 6)
        busImage.contentMode = .scaleAspectFit
        
        addSubview(backgroundView)
        addSubview(busImage)
        
        // Accessibility
        isAccessibilityElement = true
        accessibilityLabel = "Shuttle"
        accessibilityValue = shuttleAnnotation.shuttle.id
        accessibilityTraits = .button
        accessibilityHint = "Tap to view info about this shuttle."
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
