//
//  RouteListContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI
import Apollo

/// View to display a list of routes, including ETA and
/// next stop for the currently selected stop in
/// the passed ``GlobalDataState`` instance.
struct RouteListContentView: NetworkView {
    /// Backing view model.
    @State var viewModel: ViewModel = ViewModel()
    
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionModel: GlobalIdSelectionModel
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    @Environment(GlobalStopsModel.self) var globalStopsState: GlobalStopsModel
    @Environment(LocationDataModel.self) var locationManagerState: LocationDataModel
    
    // State that only has to do with presentation logic
    
    @State var showStopSelectionView: Bool = false
    @State var showChangelogView: Bool = false
    
    var networkArguments: RouteListNetworkArguments? {
        guard let stopId = globalStopsState.selectedStop?.id,
              let systemId = globalSystemsModel.selectedSystem?.id
        else {
            return nil
        }
        
        return RouteListNetworkArguments(systemId: systemId, stopId: stopId)
    }
    
    var locationIsBeingAutomaticallySelected: Bool {
        locationManagerState.isAuthorized && !globalStopsState.stopSelectionManuallyOverridenByUser
    }
    
    var body: some View {
        HeadingWrapperView(title: "Routes") {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Text("Current stop: \(globalStopsState.selectedStop?.name ?? "")")
                        if locationManagerState.locationIsUpdating,
                           globalStopsState.selectedStop == nil {
                            Text("Loading...")
                        }
                        
                        if locationIsBeingAutomaticallySelected {
                            Image(systemName: "location.fill")
                                .accessibilityLabel("Automatic selection enabled")
                        }
                    }
                    Button("Change stop") {
                        showStopSelectionView = true
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            
            WithInitializationView(dataInitState: viewModel.dataInitState) {
                Divider()
                
                DataWrapperView(shouldDisplayNoDataMessage: viewModel.activeRoutes.isEmpty, noDataMessage: "No routes available.") {
                    ForEach(viewModel.activeRoutes) { route in
                        RouteListItem(route: route, isInactive: false) { selectedRoute in
                            globalIdSelectionModel.selectRouteId(route.id)
                        }
                        .padding(.horizontal)
                        .buttonStyle(.plain)
                        
                        Divider()
                    }
                    
                    ForEach(viewModel.inactiveRoutes) { route in
                        RouteListItem(route: route, isInactive: true) { selectedRoute in
                            globalIdSelectionModel.selectRouteId(route.id)
                        }
                        .padding(.horizontal)
                        .buttonStyle(.plain)
                        
                        Divider()
                    }
                }
            }
        }
        .onAppear {
            restartDataUpdates()
        }
        .onChange(of: globalStopsState.selectedStop) {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
        .sheet(isPresented: $showStopSelectionView) {
            StopSelectionView()
        }
    }
}

/// View which displays a single route with all data
/// in the passed ``RouteListContentViewRoute`` object.
struct RouteListItem: View {
    let route: RouteListContentViewRoute
    let isInactive: Bool
    var action: (_ selectedShuttle: RouteListContentViewRoute) -> Void
    
    var body: some View {
        Button {
            action(route)
        } label: {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: route.colorHex))
                    .frame(width: 16, height: 16)
                
                VStack(alignment: .leading) {
                    Text(route.name)
                        .bold()
                    Text("Towards \(route.nextStopName ?? "unknown stop")")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(isInactive ? "N/A" : route.etaDisplayString)
            }
            .listRowBackground(Color.clear)
            .contentShape(Rectangle())
        }
        .opacity(isInactive ? 0.5 : 1.0)
    }
}

#Preview {
    let globalDataStateObject = GlobalIdSelectionModel.buildPlaceholder()
    
    let viewModel = RouteListContentView.ViewModel.buildPlaceholder()
    
    let globalStopsModel = GlobalStopsModel.buildPlaceholder()
    
    let globalSystemsModel = GlobalSystemsModel.buildPlaceholder()
    
    return RouteListContentView(viewModel: viewModel)
        .environment(globalDataStateObject)
        .environment(LocationDataModel())
        .environment(globalStopsModel)
        .environment(globalSystemsModel)
}
