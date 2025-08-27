//
//  MapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import MapKit

// MARK: - Annotation tag structs

enum AnnotationType: Int {
    case shuttle = 0
    case stop = 1
    case parkingStructure = 2
}

struct AnnotationTag: Hashable {
    let id: String
    let type: AnnotationType
}

// MARK: - Map view

/// MapKit `Map` wrapper which displays relevant information
/// on a map.
struct MapView: NetworkView {
    /// Source of truth for the currently selected route ID and shuttle ID.
    @EnvironmentObject var globalIdSelectionModel: GlobalIdSelectionModel
    @EnvironmentObject var globalSystemsModel: GlobalSystemsModel
    
    /// Source of truth for the currently selected stop ID and the list of stops.
    @EnvironmentObject var globalStopsModel: GlobalStopsModel
    
    /// Backing view model.
    @StateObject var viewModel = ViewModel()
    
    var tabSelection: Tabs
    
    var networkArguments: MapViewNetworkArguments? {
        guard let systemId = globalSystemsModel.selectedSystem?.id else { return nil }
        
        return MapViewNetworkArguments(systemId: systemId)
    }
    
    @State var mapHeading = 0.0
    
    @State var selectedTag: AnnotationTag?
    
    var body: some View {
        Map(position: $viewModel.position, interactionModes: [.pan, .zoom, .rotate], selection: $selectedTag) {
            UserAnnotation()
            
            if tabSelection == .shuttles {
                // MARK: Polyline rendering
                
                if let selectedRouteId = globalIdSelectionModel.selectedRouteId {
                    let routeToDisplay = viewModel.routes.first { route in
                        route.id == selectedRouteId
                    }
                    
                    if let routeToDisplay = routeToDisplay {
                        MapPolyline(coordinates: routeToDisplay.polylineCoordinates)
                            .stroke(Color(hex: routeToDisplay.colorHex), lineWidth: 5)
                    }
                } else {
                    ForEach(viewModel.routes) { route in
                        if let selectedStop = globalStopsModel.selectedStop {
                            if selectedStop.routeIds.contains(route.id) {
                                MapPolyline(coordinates: route.polylineCoordinates)
                                    .stroke(Color(hex: route.colorHex).opacity(0.2), lineWidth: 5)
                            }
                        }
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
                
                if let routeId = globalIdSelectionModel.selectedRouteId {
                    ForEach(viewModel.stops) { stop in
                        if stop.routeIds.contains(routeId) {
                            buildStopAnnotation(stop: stop)
                        }
                    }
                } else if let selectedStop = globalStopsModel.selectedStop,
                          let stopToRender = viewModel.stops.first(where: { $0.id == selectedStop.id }) {
                    buildStopAnnotation(stop: stopToRender)
                }
            } else if tabSelection == .parking {
                ForEach(viewModel.parkingStructures) { structure in
                    buildParkingStructureAnnotation(parkingStructure: structure)
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .mapStyle(.standard(emphasis: .muted, pointsOfInterest: []))
        .onAppear {
            restartDataUpdates()
        }
        .onChange(of: globalSystemsModel.selectedSystem) {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
        // Reset the map position if the user selects something
        .onChange(of: globalIdSelectionModel.selectedRouteId) {
            viewModel.position = .automatic
        }
        .onChange(of: [globalIdSelectionModel.selectedShuttleId, globalStopsModel.selectedStopIdOnMap, globalIdSelectionModel.selectedParkingStructureId]) {
            // TODO: center the map around the selected shuttle
            viewModel.position = .automatic
            
            if let selectedShuttleId = globalIdSelectionModel.selectedShuttleId {
                selectedTag = .init(id: selectedShuttleId, type: .shuttle)
            } else if let selectedStopId = globalStopsModel.selectedStopIdOnMap {
                selectedTag = .init(id: selectedStopId, type: .stop)
            } else if let selectedParkingStructureId = globalIdSelectionModel.selectedParkingStructureId {
                selectedTag = .init(id: selectedParkingStructureId, type: .parkingStructure)
            } else {
                selectedTag = nil
            }
        }
        .onMapCameraChange(frequency: .continuous) { cameraContext in
            mapHeading = cameraContext.camera.heading
        }
        .onChange(of: selectedTag) {
            updateGlobalSelectionStatesFromSelectedTag()
        }
    }
    
    private func updateGlobalSelectionStatesFromSelectedTag() {
        guard let selectedTag = selectedTag else {
            return
        }
        
        if selectedTag.type == .shuttle {
            globalStopsModel.selectedStopIdOnMap = nil
            globalIdSelectionModel.selectedShuttleId = selectedTag.id
            globalIdSelectionModel.selectedParkingStructureId = nil
        } else if selectedTag.type == .parkingStructure {
            globalStopsModel.selectedStopIdOnMap = nil
            globalIdSelectionModel.selectedParkingStructureId = selectedTag.id
            globalIdSelectionModel.selectedShuttleId = nil
        } else {
            globalStopsModel.selectedStopIdOnMap = selectedTag.id
            globalIdSelectionModel.selectedShuttleId = nil
            globalIdSelectionModel.selectedParkingStructureId = nil
        }
    }
}

// MARK: - Parking rendering
extension MapView {
    func buildParkingStructureAnnotation(parkingStructure: MapViewParkingStructure) -> some MapContent {
        Annotation(
            parkingStructure.name,
            coordinate: parkingStructure.coordinates,
            anchor: .center
        ) {
            ParkingStructureAnnotationView(structure: parkingStructure, shouldBeTransparent: shouldBeTransparent(for: parkingStructure))
        }
        .tag(
            AnnotationTag(id: parkingStructure.id, type: .parkingStructure)
        )
    }
    
    private func shouldBeTransparent(for parkingStructure: MapViewParkingStructure) -> Bool {
        return globalIdSelectionModel.selectedParkingStructureId != nil && globalIdSelectionModel.selectedParkingStructureId != parkingStructure.id
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
        .tag(
            AnnotationTag(id: stop.id, type: .stop)
        )
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
                shouldBeTransparent: shouldBeTransparent(for: shuttle),
                mapHeading: mapHeading
            )
        }
        .annotationTitles(
            globalIdSelectionModel.selectedShuttleId == shuttle.id ? .visible : .hidden
        )
        .tag(
            AnnotationTag(id: shuttle.id, type: .shuttle)
        )
    }
    
    private func getAssociatedStop(for shuttle: MapViewShuttle, in stops: [MapViewStop]) -> MapViewStop? {
        stops.first { $0.id == globalStopsModel.selectedStop?.id }
    }
    
    private func shouldDisplayShuttleOnMap(_ shuttle: MapViewShuttle, associatedStop: MapViewStop?) -> Bool {
        (globalIdSelectionModel.selectedRouteId != nil && shuttle.routeId == globalIdSelectionModel.selectedRouteId)
        ||
        (globalIdSelectionModel.selectedRouteId == nil && associatedStop != nil && associatedStop!.routeIds.contains(shuttle.routeId ?? ""))
    }
    
    private func shouldDisplayOrientation(for shuttle: MapViewShuttle) -> Bool {
        globalIdSelectionModel.selectedShuttleId == shuttle.id ||
        (globalIdSelectionModel.selectedShuttleId == nil && shuttle.routeId == globalIdSelectionModel.selectedRouteId)
    }
    
    private func shouldBeTransparent(for shuttle: MapViewShuttle) -> Bool {
        globalIdSelectionModel.selectedShuttleId != nil && globalIdSelectionModel.selectedShuttleId != shuttle.id
    }
}

// MARK: - Preview
#Preview {
    let builder = MapView.PlaceholderBuilder()
    let viewModel = builder.build()
    
    let stopToSelectFromViewModel = viewModel.stops.first!
    
    let globalStopsModel = GlobalStopsModel()
    globalStopsModel.stops = [
        .init(name: stopToSelectFromViewModel.name, id: stopToSelectFromViewModel.id, coordinates: .init(latitude: stopToSelectFromViewModel.coordinates.latitude, longitude: stopToSelectFromViewModel.coordinates.longitude))
    ]
    globalStopsModel.selectStopId(stopToSelectFromViewModel.id)
    
    let globalDataModel = GlobalIdSelectionModel()
    let routeToSelect = viewModel.routes.first!
    globalDataModel.selectedRouteId = routeToSelect.id
    
    return MapView(viewModel: viewModel, tabSelection: .shuttles)
        .environmentObject(globalDataModel)
        .environmentObject(globalStopsModel)
        .environmentObject(GlobalSystemsModel())
}

