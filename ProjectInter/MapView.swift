//
//  MapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var globalDataState: GlobalDataState
    
    @StateObject var viewModel = MapViewModel()
    
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
            
            if let systemId = globalDataState.selectedSystem?.id {
                viewModel.refreshData(systemId: systemId)
            }
        }
        .onChange(of: globalDataState.selectedSystem) {
            if let systemId = globalDataState.selectedSystem?.id {
                viewModel.refreshData(systemId: systemId)
            }
        }
        .onChange(of: globalDataState.selectedRouteId) {
            viewModel.position = .automatic
        }
        .onChange(of: globalDataState.selectedShuttleId) {
            viewModel.position = .automatic
        }
    }
}

#Preview {
    MapView()
        .environmentObject(GlobalDataState())
}
