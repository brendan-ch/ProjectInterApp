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
    var showSheet: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(180), .height(360), .large], selection: .constant(showSheet ? .height(360) : .height(180)))
            .presentationBackground(.ultraThickMaterial)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
    }
}

extension View {
    func sheetViewModifier(showSheet: Bool) -> some View {
        self.modifier(SheetViewModifier(showSheet: showSheet))
    }
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
    
    @EnvironmentObject var globalDataState: GlobalDataModel
    @EnvironmentObject var locationManagerState: GlobalLocationDataModel
    
    @State var routeListSheetSelectedDetent: PresentationDetent = .height(360)
    @State var routeInfoSheetSelectedDetent: PresentationDetent = .height(360)
    @State var shuttleInfoSheetSelectedDetent: PresentationDetent = .height(360)
    
    @State var currentSheetHeight: CGFloat = 360
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                MapView()
                    .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: currentSheetHeight, trailing: 0))
            }
        }
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            sheetContent
        }
    }
    
    var sheetContent: some View {
        RouteListContentView()
            .sheet(isPresented: .constant(showRouteInfo)) {
                RouteInfoContentView()
                    .sheet(isPresented: .constant(showShuttleInfoOverRouteInfo)) {
                        ShuttleInfoContentView()
                            .presentationDetents([.height(120), .height(360), .height(720)], selection: $shuttleInfoSheetSelectedDetent)
                            .presentationBackgroundInteraction(.enabled)
                            .interactiveDismissDisabled()
                    }
                    .presentationDetents([.height(120), .height(360), .height(720)], selection: $routeInfoSheetSelectedDetent)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: .constant(showShuttleInfoOverRouteList)) {
                ShuttleInfoContentView()
                    .presentationDetents([.height(120), .height(360), .height(720)], selection: $shuttleInfoSheetSelectedDetent)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
            .presentationDetents([.height(120), .height(360), .height(720)], selection: $routeListSheetSelectedDetent)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
            .background {
                // This changes for all the sheets, not just
                // the currently selected one
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
}

#Preview {
    return ContentView()
        .environmentObject(GlobalDataModel())
        .environmentObject(GlobalStopsModel())
        .environmentObject(GlobalLocationDataModel())
}
