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
struct RouteListContentView: View {
    /// Backing view model.
    @StateObject var viewModel: RouteListContentViewModel = RouteListContentViewModel()
    
    @EnvironmentObject var globalDataState: GlobalDataModel
    @EnvironmentObject var globalStopsState: GlobalStopsModel
    @EnvironmentObject var locationManagerState: GlobalLocationDataModel
    
    // State that only has to do with presentation logic
    
    @State var showStopSelectionView: Bool = false
    @State var showChangelogView: Bool = false
    
    var routeListNetworkArguments: RouteListNetworkArguments? {
        guard let stopId = globalStopsState.selectedStop?.id,
              let systemId = globalDataState.selectedSystem?.id
        else {
            return nil
        }
        
        return RouteListNetworkArguments(systemId: systemId, stopId: stopId)
    }
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Routes")
                        .font(.title2)
                        .bold()
                    HStack(spacing: 0) {
                        Text("Current stop: \(globalStopsState.selectedStop?.name ?? "")")
                        if locationManagerState.locationIsUpdating {
                            Text("Loading...")
                        }
                    }
                    Button("Change stop") {
                        showStopSelectionView = true
                    }
                }
                Spacer()
            }
            .padding()
            
            // Display location banner if not authorized
            if locationManagerState.authorizationStatus == .notDetermined {
                EnableLocationAccessGroupBoxView {
                    locationManagerState.requestAuthorization()
                }
            }
            
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
            if let apolloClient = globalDataState.apolloClient {
                viewModel.apolloClient = apolloClient
            }
        }
        .onChange(of: globalStopsState.selectedStop) {
            // Refresh data in backing view model
            if let arguments = routeListNetworkArguments {
                viewModel.stopRefreshingData()
                viewModel.startRefreshingData(arguments: arguments)
            }
        }
        .sheet(isPresented: $showStopSelectionView) {
            StopSelectionView()
        }
        .sheet(isPresented: $showChangelogView) {
            if let url = URL(string: "https://interchange.bchen.dev/changelog") {
                NonPersistentWebView(url: url, accessibilityIdentifier: "ChangelogWebView")
            }
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

struct EnableLocationAccessGroupBoxView: View {
    var onPressGrant: () -> Void
    
    // TODO: fix the spacing
    var body: some View {
        GroupBox(label: Label("Enable Location Access", systemImage: "location")) {
            VStack(alignment: .leading, spacing: 8) {
                Text("See times for your closest stop, get notifications for shuttles, and more.")
                Button("Grant location access") {
                    onPressGrant()
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .presentationBackground(.ultraThickMaterial)
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
