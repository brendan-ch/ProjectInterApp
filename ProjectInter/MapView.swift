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
    
    /// Backing view model.
    @StateObject var viewModel = MapViewModel()
    
    var mapViewNetworkArguments: MapViewNetworkArguments? {
        guard let systemId = globalDataState.selectedSystem?.id else { return nil }
        
        return MapViewNetworkArguments(systemId: systemId)
    }
    
    var body: some View {
        Map(position: $viewModel.position, selection: $globalDataState.selectedShuttleId) {
            UserAnnotation()
            
            if let routeId = globalDataState.selectedRouteId {
                let routeToDisplay = viewModel.routes.first { route in
                    route.id == routeId
                }
                
                if let routeToDisplay = routeToDisplay {
                    MapPolyline(coordinates: routeToDisplay.polylineCoordinates)
                        .stroke(Color(hex: routeToDisplay.colorHex), lineWidth: 5)
                }
            }
            
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
        }
        .onAppear {
            if let client = globalDataState.apolloClient {
                viewModel.apolloClient = client
            } else {
                viewModel.addPlaceholderData()
            }
            
            if let arguments = mapViewNetworkArguments {
                viewModel.refreshData(arguments: arguments)
            }
        }
        .onChange(of: globalDataState.selectedSystem) {
            if let arguments = mapViewNetworkArguments {
                viewModel.refreshData(arguments: arguments)
            }
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
}

#Preview {
    MapView()
        .environmentObject(GlobalDataModel())
}
