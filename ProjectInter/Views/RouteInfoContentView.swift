//
//  RouteInfoContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

/// View which displays information for the currently selected
/// route in ``GlobalDataState`` and a list of upcoming shuttles.
struct RouteInfoContentView: NetworkView {
    /// ``GlobalDataState`` instance containing the currently selected route
    /// and `ApolloClient` instance.
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionModel: GlobalIdSelectionModel
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    
    @Environment(GlobalStopsModel.self) var globalStopsState: GlobalStopsModel
    
    @Environment(ShuttleInfoContentView.ViewModel.self) var shuttleViewModel: ShuttleInfoContentView.ViewModel?
    
    /// Backing ``RouteInfoContentView`` instance.
    @State var viewModel: ViewModel = ViewModel()
    
    var networkArguments: RouteInfoNetworkArguments? {
        guard let systemId = globalSystemsModel.selectedSystem?.id,
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
                    globalIdSelectionModel.selectedRouteId = nil
                    globalIdSelectionModel.selectedShuttleId = nil
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.shuttles) { shuttle in
                                Button {
                                    globalIdSelectionModel.selectedShuttleId = shuttle.id
                                } label: {
                                    VStack {
                                        Text(shuttle.name)
                                            .bold()
                                        if let secondsRemaining = shuttle.secondsRemaining {
                                            Text(secondsRemaining.convertToMinutesAsString() + " min")
                                        } else {
                                            Text("N/A")
                                        }
                                    }
                                }
                                .controlSize(.regular)
                                .prominentButtonStyleByAvailability()
                            }
                        }
                        .padding()
                    }
                    
                    if let shuttleViewModel = shuttleViewModel {
                        ShuttleInfoContentView(viewModel: shuttleViewModel)
                    } else {
                        ShuttleInfoContentView()
                    }
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
    let model = RouteInfoContentView.ViewModel.buildPlaceholder()
    let shuttleViewModel = ShuttleInfoContentView.ViewModel.buildPlaceholder()
    
    return RouteInfoContentView(viewModel: model)
        .environment(GlobalIdSelectionModel())
        .environment(GlobalStopsModel())
        .environment(GlobalSystemsModel.buildPlaceholder())
        .environment(ShuttleNotificationSchedulingModel())
        .environment(shuttleViewModel)
        .environmentObject(CustomAppDelegate())
}
