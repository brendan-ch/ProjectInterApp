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
    let standardPresentationDetents: Set<PresentationDetent> = [.height(160), .height(360), .height(720)]
    
    func body(content: Content) -> some View {
        content
            .presentationBackground(.ultraThickMaterial)
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
        globalIdSelectionModel.selectedShuttleId != nil
        && globalIdSelectionModel.selectedRouteId == nil
    }
    var showRouteInfo: Bool {
        globalIdSelectionModel.selectedRouteId != nil
    }
    var showParkingStructureInfo: Bool {
        globalIdSelectionModel.selectedParkingStructureId != nil
    }
    
    // For dependency injection in previews
    var mapViewModel: MapView.ViewModel?
    var routeListContentViewModel: RouteListContentView.ViewModel?
    var routeInfoContentViewModel: RouteInfoContentView<ShuttleInfoContentView>.ViewModel?
    var shuttleInfoContentViewModel: ShuttleInfoContentView.ViewModel?
    var parkingStructuresListContentViewModel: ParkingStructuresListContentView.ViewModel?
    
    @Environment(GlobalIdSelectionModel.self) var globalIdSelectionModel: GlobalIdSelectionModel
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    @Environment(LocationDataModel.self) var locationManagerState: LocationDataModel
    
    @State var routeListSheetSelectedDetent: PresentationDetent = .height(360)
    @State var routeInfoSheetSelectedDetent: PresentationDetent = .height(360)
    @State var shuttleInfoSheetSelectedDetent: PresentationDetent = .height(360)
    @State var parkingInfoSheetSelectedDetent: PresentationDetent = .height(360)

    
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
        .onChange(of: globalSystemsModel.selectedSystem) {
            tabSelection = .shuttles
        }
        .onChange(of: globalIdSelectionModel.selectedShuttleId) {
            if globalIdSelectionModel.selectedShuttleId != nil {
                tabSelection = .shuttles
            }
        }
        .onChange(of: globalIdSelectionModel.selectedRouteId) {
            if globalIdSelectionModel.selectedRouteId != nil {
                tabSelection = .shuttles
            }
        }
        .onChange(of: globalIdSelectionModel.selectedParkingStructureId) {
            if globalIdSelectionModel.selectedParkingStructureId != nil {
                tabSelection = .parking
            }
        }
    }
    
    func buildSheetContent() -> some View {
        TabView(selection: $tabSelection) {
            Tab("Shuttles", systemImage: "bus.fill", value: .shuttles) {
                buildRouteListView()
                    .sheet(isPresented: .constant(showRouteInfo)) {
                        buildRouteInfoView()
                            .sheetViewModifier(detentSelection: $routeInfoSheetSelectedDetent)
                    }
            }
            Tab("Parking", systemImage: "parkingsign.square.fill", value: .parking) {
                buildParkingStructuresListView()
                    .sheet(isPresented: .constant(showParkingStructureInfo)) {
                        buildParkingStructureInfoView()
                            .sheetViewModifier(detentSelection: $parkingInfoSheetSelectedDetent)
                    }
            }
            Tab("Settings", systemImage: "gear", value: .settings) {
                buildSettingsView()
            }
        }
        .sheetViewModifier(detentSelection: $routeListSheetSelectedDetent)
        .background {
            // This changes for all the sheets, not just
            // the currently selected one
            // https://stackoverflow.com/questions/74423799/how-to-size-content-for-presentation-detents-in-swiftui
            GeometryReader { proxy in
                Color.clear.opacity(0.0)
                    .onChange(of: proxy.size.height) {
                        if proxy.size.height <= 360 {
                            currentSheetHeight = proxy.size.height
                        }
                    }
            }
        }
        .presentationBackground(.ultraThickMaterial)
    }
    
    func buildSettingsView() -> some View {
        return SettingsContentView()
    }
    
    func buildParkingStructuresListView() -> some View {
        if let parkingStructuresContentViewModel = parkingStructuresListContentViewModel {
            return ParkingStructuresListContentView(viewModel: parkingStructuresContentViewModel)
        }
        return ParkingStructuresListContentView()
    }
    
    func buildParkingStructureInfoView() -> some View {
        return ParkingStructureInfoContentView()
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
            return RouteInfoContentView(viewModel: routeInfoContentViewModel) {
                buildShuttleInfoView()
            }
        }
        return RouteInfoContentView() {
            buildShuttleInfoView()
        }
    }
    
    func buildShuttleInfoView() -> ShuttleInfoContentView {
        if let shuttleInfoContentViewModel = shuttleInfoContentViewModel {
            return ShuttleInfoContentView(viewModel: shuttleInfoContentViewModel)
        }
        return ShuttleInfoContentView()
    }
}

#Preview {
    let globalIdSelectionModel = GlobalIdSelectionModel.buildPlaceholder()
    
    let globalSystemsModel = GlobalSystemsModel.buildPlaceholder()
    
    let globalStopsModel = GlobalStopsModel.buildPlaceholder()
    
    let mapViewModel = MapView.ViewModel.buildPlaceholder()
    
    let routeListContentViewModel = RouteListContentView.ViewModel.buildPlaceholder()
    
    let routeInfoContentViewModel = RouteInfoContentView<ShuttleInfoContentView>.ViewModel.buildPlaceholder()
    
    let shuttleInfoContentViewModel = ShuttleInfoContentView.ViewModel.buildPlaceholder()
    
    let parkingStructuresViewModel = ParkingStructuresListContentView.ViewModel.buildPlaceholder()
    
    return ContentView(
        mapViewModel: mapViewModel,
        routeListContentViewModel: routeListContentViewModel,
        routeInfoContentViewModel: routeInfoContentViewModel,
        shuttleInfoContentViewModel: shuttleInfoContentViewModel,
        parkingStructuresListContentViewModel: parkingStructuresViewModel
    )
        .environment(globalIdSelectionModel)
        .environment(globalSystemsModel)
        .environment(globalStopsModel)
        .environment(LocationDataModel())
}
