//
//  RouteInfoContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

/// View which displays information for the currently selected
/// route in ``GlobalDataState`` and a list of upcoming shuttles.
struct RouteInfoContentView<Content: View>: NetworkView {
    /// ``GlobalDataState`` instance containing the currently selected route
    /// and `ApolloClient` instance.
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionModel: GlobalIdSelectionModel
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    
    @Environment(GlobalStopsModel.self) var globalStopsState: GlobalStopsModel
    
    /// Backing ``RouteInfoContentView`` instance.
    @State var viewModel: ViewModel = ViewModel()
    
    @ViewBuilder let shuttleInfo: Content
    
    var networkArguments: RouteInfoNetworkArguments? {
        guard let systemId = globalSystemsModel.locallyPersistedSelectedSystemId,
              let stopId = globalStopsState.selectedStop?.id,
              let routeId = globalIdSelectionModel.selectedRouteId else { return nil }
        
        return RouteInfoNetworkArguments(systemId: systemId, stopId: stopId, routeId: routeId)
    }
    
    var body: some View {
        HeadingWrapperView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(viewModel.routeName)
                        .font(.title)
                        .bold()
                    Text("Towards \(viewModel.routeNextStopName ?? "unknown stop")")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                
                CloseButton {
                    globalIdSelectionModel.clearAllIds()
                }
            }
            .padding()
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
        } content: {
            WithInitializationView(dataInitState: viewModel.dataInitState) {
                DataWrapperView(
                    shouldDisplayNoDataMessage: viewModel.shuttles.isEmpty,
                    noDataMessage: "No shuttles available"
                ) {
                    VStack(spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.shuttles) { shuttle in
                                    Button {
                                        globalIdSelectionModel.selectShuttleIdIfRouteIdSelected(shuttle.id)
                                    } label: {
                                        VStack {
                                            Text(shuttle.name)
                                                .bold()
                                            Text(shuttle.estimatedTimeAwayDisplay)
                                        }
                                        .frame(minWidth: 80)
                                    }
                                    .controlSize(.regular)
                                    .accessibilityAddTraits(shuttle.id == globalIdSelectionModel.selectedShuttleId ? .isSelected : [])
                                    .apply(shuttle.id == globalIdSelectionModel.selectedShuttleId) {
                                        $0
                                            .prominentButtonStyleByAvailability()
                                    }
                                    .apply(shuttle.id != globalIdSelectionModel.selectedShuttleId) {
                                        $0.secondaryButtonStyleByAvailability()
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        Divider()
                        
                        shuttleInfo
                    }
                }
            }
        }
        .onChange(of: viewModel.dataInitState) {
            if viewModel.dataInitState == .succeeded {
                if !viewModel.shuttles.isEmpty && globalIdSelectionModel.selectedShuttleId == nil {
                    globalIdSelectionModel.selectShuttleIdIfRouteIdSelected(viewModel.shuttles[0].id)
                }
            }
        }
        .onAppear {
            restartDataUpdates()
        }
        .onChange(of: globalIdSelectionModel.selectedRouteId) {
            restartDataUpdates()
        }
        .onDisappear {
            stopDataUpdates()
        }
    }
}

struct RouteInfoShuttleViewItem: View {
    var shuttle: RouteInfoContentViewShuttle
    var action: (_ selectedShuttle: RouteInfoContentViewShuttle) -> Void
    
    var body: some View {
        Button {
            action(shuttle)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(shuttle.name)
                        .bold()
                    Text(shuttle.estimatedTimeAwayDisplay)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    let model = RouteInfoContentView<ShuttleInfoContentView>.ViewModel.buildPlaceholder()
    let shuttleViewModel = ShuttleInfoContentView.ViewModel.buildPlaceholder()
    
    RouteInfoContentView(viewModel: model) {
        ShuttleInfoContentView(viewModel: shuttleViewModel)
    }
        .environment(GlobalIdSelectionModel())
        .environment(GlobalStopsModel())
        .environment(GlobalSystemsModel.buildPlaceholder())
        .environmentObject(CustomAppDelegate())
}
