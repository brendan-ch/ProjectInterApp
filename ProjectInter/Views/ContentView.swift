//
//  ContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData
import MapKit

struct SheetViewModifier: ViewModifier {
    let detentSelection: Binding<PresentationDetent>
    let standardPresentationDetents: Set<PresentationDetent> = [.height(96), .height(360), .height(720)]
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents(standardPresentationDetents, selection: detentSelection)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
    }
}

extension View {
    func sheetViewModifier(detentSelection: Binding<PresentationDetent>) -> some View {
        self.modifier(SheetViewModifier(detentSelection: detentSelection))
    }
}

enum Tabs {
    case shuttles
    case parking
    case settings
}


/// The primary view of the app. Controls map height adjustment and
/// which sheet is displayed.
struct ContentView: View {
    /// Whether the root-level sheet should be showing.
    @State var showSheet = false
    var showShuttleInfoOverRouteList: Bool {
        globalDataState.selectedShuttleId != nil
        && globalDataState.selectedRouteId == nil
    }
    var showRouteInfo: Bool {
        globalDataState.selectedRouteId != nil
    }
    var showShuttleInfoOverRouteInfo: Bool {
        globalDataState.selectedRouteId != nil
        && globalDataState.selectedShuttleId != nil
    }
    
    // For dependency injection in previews
    var mapViewModel: MapViewModel?
    var routeListContentViewModel: RouteListContentViewModel?
    var routeInfoContentViewModel: RouteInfoContentViewModel?
    var shuttleInfoContentViewModel: ShuttleInfoContentViewModel?
    var parkingStructuresContentViewModel: ParkingStructuresListContentViewModel?
    
    @EnvironmentObject var globalDataState: GlobalDataModel
    @EnvironmentObject var locationManagerState: GlobalLocationDataModel
    
    // Not actually used to set anything, just to provide default values
    @State var routeListSheetSelectedDetent: PresentationDetent = .height(360)
    @State var routeInfoSheetSelectedDetent: PresentationDetent = .height(360)
    @State var shuttleInfoSheetSelectedDetent: PresentationDetent = .height(360)
    
    
    // Controls the map height
    @State var currentSheetHeight: CGFloat = 360
    
    @State var tabSelection: Tabs = .shuttles
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                buildMapView()
                    .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: currentSheetHeight, trailing: 0))
            }
        }
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            buildSheetContent()
        }
    }
    
    func buildSheetContent() -> some View {
        TabView(selection: $tabSelection) {
            Tab("Shuttles", systemImage: "bus.fill", value: .shuttles) {
                buildRouteListView()
                    .sheet(isPresented: .constant(showRouteInfo)) {
                        buildRouteInfoView()
                            .sheet(isPresented: .constant(showShuttleInfoOverRouteInfo)) {
                                buildShuttleInfoView()
                                    .sheetViewModifier(detentSelection: $shuttleInfoSheetSelectedDetent)
                            }
                            .sheetViewModifier(detentSelection: $routeInfoSheetSelectedDetent)
                    }
                    .sheet(isPresented: .constant(showShuttleInfoOverRouteList)) {
                        buildShuttleInfoView()
                            .sheetViewModifier(detentSelection: $shuttleInfoSheetSelectedDetent)
                    }
            }
            Tab("Parking", systemImage: "parkingsign.square.fill", value: .parking) {
                buildParkingStructuresView()
            }
            Tab("Settings", systemImage: "gear", value: .settings) {
                Text("Settings")
            }
        }
        .sheetViewModifier(detentSelection: $routeListSheetSelectedDetent)
        .background {
            // This changes for all the sheets, not just
            // the currently selected one
            // https://stackoverflow.com/questions/74423799/how-to-size-content-for-presentation-detents-in-swiftui
            GeometryReader { proxy in
                Color.clear
                    .onChange(of: proxy.size.height) {
                        if proxy.size.height <= 360 {
                            currentSheetHeight = proxy.size.height
                        }
                    }
            }
        }
    }
    
    func buildParkingStructuresView() -> some View {
        if let parkingStructuresContentViewModel = parkingStructuresContentViewModel {
            return ParkingStructuresListContentView(viewModel: parkingStructuresContentViewModel)
        }
        return ParkingStructuresListContentView()
    }
    
    func buildMapView() -> some View {
        if let mapViewModel = mapViewModel {
            return MapView(viewModel: mapViewModel, tabSelection: tabSelection)
        }
        return MapView(tabSelection: tabSelection)
    }
    
    func buildRouteListView() -> some View {
        if let routeListContentViewModel = routeListContentViewModel {
            return RouteListContentView(viewModel: routeListContentViewModel)
        }
        return RouteListContentView()
    }
    
    func buildRouteInfoView() -> some View {
        if let routeInfoContentViewModel = routeInfoContentViewModel {
            return RouteInfoContentView(viewModel: routeInfoContentViewModel)
        }
        return RouteInfoContentView()
    }
    
    func buildShuttleInfoView() -> some View {
        if let shuttleInfoContentViewModel = shuttleInfoContentViewModel {
            return ShuttleInfoContentView(viewModel: shuttleInfoContentViewModel)
        }
        return ShuttleInfoContentView()
    }
}

#Preview {
    let globalDataModelBuilder = GlobalDataModelPlaceholderBuilder()
    let globalDataModel = globalDataModelBuilder.build()
    
    let globalStopsModelBuilder = GlobalStopsModelPlaceholderBuilder()
    let globalStopsModel = globalStopsModelBuilder.build()
    
    let mapViewModelBuilder = MapViewModelPlaceholderBuilder()
    let mapViewModel = mapViewModelBuilder.build()
    
    let routeListContentViewModelBuilder = RouteListContentViewModelPlaceholderBuilder()
    let routeListContentViewModel = routeListContentViewModelBuilder.build()
    
    let routeInfoContentViewModelBuilder = RouteInfoContentViewModelPlaceholderBuilder()
    let routeInfoContentViewModel = routeInfoContentViewModelBuilder.build()
    
    let shuttleInfoContentViewModelBuilder = ShuttleInfoContentViewModelPlaceholderBuilder()
    let shuttleInfoContentViewModel = shuttleInfoContentViewModelBuilder.build()
    
    let parkingStructuresContentViewModelBuilder = ParkingStructuresListContentViewModelPlaceholderBuilder()
    let parkingStructuresViewModel = parkingStructuresContentViewModelBuilder.build()
    
    return ContentView(
        mapViewModel: mapViewModel,
        routeListContentViewModel: routeListContentViewModel,
        routeInfoContentViewModel: routeInfoContentViewModel,
        shuttleInfoContentViewModel: shuttleInfoContentViewModel,
        parkingStructuresContentViewModel: parkingStructuresViewModel
    )
        .environmentObject(globalDataModel)
        .environmentObject(globalStopsModel)
        .environmentObject(GlobalLocationDataModel())
}
