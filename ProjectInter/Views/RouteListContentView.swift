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
    @StateObject var viewModel: RouteListContentViewModel = RouteListContentViewModel()
    
    @EnvironmentObject var globalDataModel: GlobalDataModel
    @EnvironmentObject var globalStopsState: GlobalStopsModel
    @EnvironmentObject var locationManagerState: GlobalLocationDataModel
    
    // State that only has to do with presentation logic
    
    @State var showStopSelectionView: Bool = false
    @State var showChangelogView: Bool = false
    
    var networkArguments: RouteListNetworkArguments? {
        guard let stopId = globalStopsState.selectedStop?.id,
              let systemId = globalDataModel.selectedSystem?.id
        else {
            return nil
        }
        
        return RouteListNetworkArguments(systemId: systemId, stopId: stopId)
    }
    
    var body: some View {
        RootSheetContentView(title: "Routes") {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Text("Current stop: \(globalStopsState.selectedStop?.name ?? "")")
                        if locationManagerState.locationIsUpdating,
                           globalStopsState.selectedStop == nil {
                            Text("Loading...")
                        }
                        
                        if globalStopsState.isAutomaticWhenLocationIsAvailable {
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
            
            Divider()
            ForEach(viewModel.routes) { route in
                RouteListItem(route: route) { selectedRoute in
                    globalDataState.selectedRouteId = route.id
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                
                Divider()
            }
            
            RouteListFooter {
                showChangelogView = true
            }
            .padding()
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
        .sheet(isPresented: $showChangelogView) {
            ChangelogWebView()
        }
    }
}

/// View which displays a single route with all data
/// in the passed ``RouteListContentViewRoute`` object.
struct RouteListItem: View {
    var route: RouteListContentViewRoute
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
                Text(route.etaDisplayString)
            }
            .listRowBackground(Color.clear)
            .contentShape(Rectangle())
        }
    }
}

struct RouteListFooter: View {
    @StateObject var changelogVersionModel = AppVersionModel()
    
    var onChangelogButtonPress: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            if let marketingVersion = changelogVersionModel.getCurrentAppMarketingVersion() {
                Text("Interchange version \(marketingVersion)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Text("This app is a work in progress.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Button {
                onChangelogButtonPress()
                changelogVersionModel.updateLastViewedChangelogVersion()
            } label: {
                HStack(alignment: .center, spacing: 4) {
                    Text("See what's new")
                    if changelogVersionModel.shouldShowNewUpdatesIndicator {
                        Circle()
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .font(.footnote)
        }
    }
}

#Preview {
    let globalDataModelBuilder = GlobalDataModelPlaceholderBuilder()
    let globalDataStateObject = globalDataModelBuilder.build()
    
    let viewModelBuilder = RouteListContentViewModelPlaceholderBuilder()
    let viewModel = viewModelBuilder.build()
    
    let globalStopModelBuilder = GlobalStopsModelPlaceholderBuilder()
    let globalStopsModel = globalStopModelBuilder.build()
    
    return RouteListContentView(viewModel: viewModel)
        .environmentObject(globalDataStateObject)
        .environmentObject(GlobalLocationDataModel())
        .environmentObject(globalStopsModel)
}
