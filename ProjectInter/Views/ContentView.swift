//
//  ContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData
import MapKit
import Combine

struct SheetViewModifier: ViewModifier {
    let detentSelection: Binding<PresentationDetent>
    let standardPresentationDetents: Set<PresentationDetent> = [.height(120), .height(360), .height(720)]
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents(standardPresentationDetents, selection: detentSelection)
            .presentationBackground(.ultraThickMaterial)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
    }
}

extension View {
    func sheetViewModifier(detentSelection: Binding<PresentationDetent>) -> some View {
        self.modifier(SheetViewModifier(detentSelection: detentSelection))
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
    
    // Not actually used to set anything, just to provide default values
    @State var routeListSheetSelectedDetent: PresentationDetent = .height(360)
    @State var routeInfoSheetSelectedDetent: PresentationDetent = .height(360)
    @State var shuttleInfoSheetSelectedDetent: PresentationDetent = .height(360)
    
    
    // Controls the map height
    @State var currentSheetHeight: CGFloat = 360
    
    // Used to implement debounce for map height updates
    @State private var heightPublisher = PassthroughSubject<CGFloat, Never>()
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                MapView(layoutMarginBottomValue: currentSheetHeight)
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
                            .sheetViewModifier(detentSelection: $shuttleInfoSheetSelectedDetent)
                    }
                    .sheetViewModifier(detentSelection: $routeInfoSheetSelectedDetent)
            }
            .sheet(isPresented: .constant(showShuttleInfoOverRouteList)) {
                ShuttleInfoContentView()
                    .sheetViewModifier(detentSelection: $shuttleInfoSheetSelectedDetent)
            }
            .sheetViewModifier(detentSelection: $routeListSheetSelectedDetent)
            .onAppear {
                cancellable = heightPublisher
                    .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                    .sink { height in
                        withAnimation {
                            currentSheetHeight = height
                        }
                    }
            }
            .background {
                // This changes for all the sheets, not just
                // the currently selected one
                // https://stackoverflow.com/questions/74423799/how-to-size-content-for-presentation-detents-in-swiftui
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.size.height) {
                            if proxy.size.height <= 360 {
                                heightPublisher.send(proxy.size.height)
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
