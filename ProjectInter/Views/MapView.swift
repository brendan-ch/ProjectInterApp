//
//  MapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import MapKit

// MARK: - Map view

/// MapKit `Map` wrapper which displays relevant information
/// on a map.
struct MapView: View {
    /// Source of truth for the currently selected route ID and shuttle ID.
    @EnvironmentObject var globalDataState: GlobalDataModel
    
    /// Source of truth for the currently selected stop ID and the list of stops.
    @EnvironmentObject var globalStopsModel: GlobalStopsModel
    
    /// Backing view model.
    @StateObject var viewModel = MapViewModel()
    
    var mapViewNetworkArguments: MapViewNetworkArguments? {
        guard let systemId = globalDataState.selectedSystem?.id else { return nil }
        
        return MapViewNetworkArguments(systemId: systemId)
    }
    
    @State var mapHeading = 0.0
    
    var body: some View {
        Map(position: $viewModel.position, interactionModes: [.pan, .zoom, .rotate], selection: $globalDataState.selectedShuttleId) {
            UserAnnotation()
            
            // MARK: Polyline rendering
            
            if let routeId = globalDataState.selectedRouteId {
                let routeToDisplay = viewModel.routes.first { route in
                    route.id == routeId
                }
                
                if let routeToDisplay = routeToDisplay {
                    MapPolyline(coordinates: routeToDisplay.polylineCoordinates)
                        .stroke(Color(hex: routeToDisplay.colorHex), lineWidth: 5)
                }
            }
            
            // MARK: Shuttle rendering
            
            ForEach(viewModel.shuttles) { shuttle in
                let associatedStop = getAssociatedStop(for: shuttle, in: viewModel.stops)
                
                if shouldDisplayShuttleOnMap(shuttle, associatedStop: associatedStop) {
                    buildShuttleAnnotation(shuttle: shuttle)
                }
            }
            
            // MARK: Stop rendering
            
            if let routeId = globalDataState.selectedRouteId {
                ForEach(viewModel.stops) { stop in
                    if stop.routeIds.contains(routeId) {
                        buildStopAnnotation(stop: stop)
                    }
                }
            } else if let selectedStop = globalStopsModel.selectedStop,
                      let stopToRender = viewModel.stops.first(where: { $0.id == selectedStop.id }) {
                buildStopAnnotation(stop: stopToRender)
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
        .mapStyle(.standard(emphasis: .muted, pointsOfInterest: []))
        .onAppear {
            if let client = globalDataState.apolloClient {
                viewModel.apolloClient = client
            }
            
            restartDataUpdatesIfArgumentsExist()
        }
        .onChange(of: globalDataState.selectedSystem) {
            restartDataUpdatesIfArgumentsExist()
        }
        // Reset the map position if the user selects something
        .onChange(of: globalDataState.selectedRouteId) {
            viewModel.position = .automatic
        }
        .onChange(of: globalDataState.selectedShuttleId) {
            // TODO: center the map around the selected shuttle
            viewModel.position = .automatic
        }
        .onMapCameraChange(frequency: .continuous) { cameraContext in
            mapHeading = cameraContext.camera.heading
        }
    }
    
    private func restartDataUpdatesIfArgumentsExist() {
        if let arguments = mapViewNetworkArguments {
            viewModel.stopRefreshingData()
            viewModel.startRefreshingData(arguments: arguments)
        }
    }
}

// MARK: - Stop rendering
extension MapView {
    func buildStopAnnotation(stop: MapViewStop) -> some MapContent {
        Annotation(
            stop.name,
            coordinate: stop.coordinates,
            anchor: .center
        ) {
            StopAnnotationView()
        }
        .annotationTitles(globalStopsModel.selectedStop?.id == stop.id ? .visible : .hidden)
    }
    
    private func stopCanBeReachedFromCurrentlySelectedStop(_ stop: MapViewStop) -> Bool {
        guard let selectedStop = globalStopsModel.selectedStop else {
            return false
        }
        for routeId in selectedStop.routeIds {
            if stop.routeIds.contains(routeId) {
                return true
            }
        }
        
        return false
    }
}

// MARK: - Shuttle rendering
extension MapView {
    func buildShuttleAnnotation(shuttle: MapViewShuttle) -> some MapContent {
        Annotation(
            shuttle.name,
            coordinate: shuttle.coordinates,
            anchor: .center
        ) {
            ShuttleAnnotationView(
                shuttle: shuttle,
                shouldDisplayOrientation: shouldDisplayOrientation(for: shuttle),
                mapHeading: mapHeading
            )
        }
        .annotationTitles(
            globalDataState.selectedShuttleId == shuttle.id ? .visible : .hidden
        )
        .tag(shuttle.id)
    }
    
    private func getAssociatedStop(for shuttle: MapViewShuttle, in stops: [MapViewStop]) -> MapViewStop? {
        stops.first { $0.id == globalStopsModel.selectedStop?.id }
    }
    
    private func shouldDisplayShuttleOnMap(_ shuttle: MapViewShuttle, associatedStop: MapViewStop?) -> Bool {
        (globalDataState.selectedRouteId != nil && shuttle.routeId == globalDataState.selectedRouteId)
        ||
        (globalDataState.selectedRouteId == nil && associatedStop != nil && associatedStop!.routeIds.contains(shuttle.routeId ?? ""))
    }
    
    private func shouldDisplayOrientation(for shuttle: MapViewShuttle) -> Bool {
        globalDataState.selectedShuttleId == shuttle.id ||
        (globalDataState.selectedShuttleId == nil && shuttle.routeId == globalDataState.selectedRouteId)
    }
}

// MARK: - Annotation views
struct StopAnnotationView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.white)
            RoundedRectangle(cornerRadius: 100)
                .stroke(.black, lineWidth: 2)
        }
    }
}

struct ShuttleAnnotationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var shuttle: MapViewShuttle
    
    var shouldDisplayOrientation = false
    
    var mapHeading: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(hex: shuttle.routeColorHex ?? "#000000"))
            RoundedRectangle(cornerRadius: 100)
                .stroke(.white, lineWidth: 4)
            Image(systemName: "bus.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(6)
                .foregroundStyle(Color.white)
            
            if shouldDisplayOrientation {
                // Direction arrow
                Triangle()
                    .fill(colorScheme == .dark ? Color.white : Color.black)
                    .frame(width: 6, height: 6)
                    .offset(y: -21)
                    .rotationEffect(.degrees(shuttle.orientationInDegrees - mapHeading))
            }
        }
        .accessibilityLabel("Shuttle")
        .accessibilityValue(shuttle.id)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Tap to view info about this shuttle.")
    }
}

// MARK: - Preview
#Preview {
    let builder = MapViewModelPlaceholderBuilder()
    let viewModel = builder.build()
    
    let stopToSelectFromViewModel = viewModel.stops.first!
    
    let globalStopsModel = GlobalStopsModel()
    globalStopsModel.selectStopManually(
        .init(name: stopToSelectFromViewModel.name, id: stopToSelectFromViewModel.id, coordinates: .init(latitude: stopToSelectFromViewModel.coordinates.latitude, longitude: stopToSelectFromViewModel.coordinates.longitude))
    )
    
    let globalDataModel = GlobalDataModel()
    let routeToSelect = viewModel.routes.first!
    globalDataModel.selectedRouteId = routeToSelect.id
    
    return MapView(viewModel: viewModel)
        .environmentObject(globalDataModel)
        .environmentObject(globalStopsModel)
}

