//
//  MapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import MapKit

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
    
    var body: some View {
        Map(position: $viewModel.position, selection: $globalDataState.selectedShuttleId) {
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
                let shouldDisplayShuttle = globalDataState.selectedRouteId != nil && shuttle.routeId == globalDataState.selectedRouteId || globalDataState.selectedRouteId == nil
                
                if shouldDisplayShuttle {
                    Annotation(
                        shuttle.name,
                        coordinate: shuttle.coordinates,
                        anchor: .center
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color(hex: shuttle.routeColorHex))
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.white, lineWidth: 4)
                            Image(systemName: "bus.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(6)
                                .foregroundStyle(Color.white)
                        }
                    }
                    .annotationTitles(
                        globalDataState.selectedShuttleId == shuttle.id ? .visible : .hidden
                    )
                    .tag(shuttle.id)
                }
            }
            
            // MARK: Stop rendering
            
            if let routeId = globalDataState.selectedRouteId {
                ForEach(viewModel.stops) { stop in
                    if stop.routeIds.contains(routeId) {
                        Annotation(
                            stop.name,
                            coordinate: stop.coordinates,
                            anchor: .center
                        ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color.white)
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(.black, lineWidth: 2)
                            }
                        }
                        .annotationTitles(globalStopsModel.selectedStop?.id == stop.id ? .visible : .hidden)
                    }
                }
            }
            else if let selectedStop = globalStopsModel.selectedStop {
                let stopToRender = viewModel.stops.first { element in
                    element.id == selectedStop.id
                }
                
                if let stopToRender = stopToRender {
                    Annotation(
                        stopToRender.name,
                        coordinate: stopToRender.coordinates,
                        anchor: .center
                    ) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.white)
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.black, lineWidth: 2)
                        }
                    }
                    .annotationTitles(.visible)
                }
            }
        }
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
    }
    
    private func restartDataUpdatesIfArgumentsExist() {
        if let arguments = mapViewNetworkArguments {
            viewModel.stopRefreshingData()
            viewModel.startRefreshingData(arguments: arguments)
        }
    }
}

#Preview {
    let builder = MapViewModelPlaceholderBuilder()
    let viewModel = builder.build()
    
    let stopToSelectFromViewModel = viewModel.stops.first!
    
    let globalStopsModel = GlobalStopsModel()
    globalStopsModel.selectedStop = .init(name: stopToSelectFromViewModel.name, id: stopToSelectFromViewModel.id, coordinates: .init(latitude: stopToSelectFromViewModel.coordinates.latitude, longitude: stopToSelectFromViewModel.coordinates.longitude))
    
    return MapView(viewModel: viewModel)
        .environmentObject(GlobalDataModel())
        .environmentObject(globalStopsModel)
}
