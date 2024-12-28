//
//  ContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import SwiftData
import MapKit

extension MKCoordinateRegion {
    static let anaheim = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.79787, longitude: -117.8937), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}


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

struct GeometryReaderSheetWrapperView<Content: View>: View {
    @Binding var height: CGFloat
    var shouldUpdate: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        GeometryReader { geometry in
            content
                .onChange(of: geometry.size) {
                    let newHeight = geometry.size.height
                    if shouldUpdate && newHeight <= 360 {
                        height = newHeight
                    }
                }
        }
    }
}


struct ContentView: View {
    @State var showSheet = false
    
    @EnvironmentObject var globalDataState: GlobalDataState
    @EnvironmentObject var locationManagerState: LocationManagerState
    
    var nestedSheetLevel: Int {
        if globalDataState.selectedRouteId != nil && globalDataState.selectedShuttleId != nil {
            return 2
        } else if globalDataState.selectedRouteId != nil || globalDataState.selectedShuttleId != nil {
            return 1
        }
        return 0
    }
    
    @State var currentSheetHeight: CGFloat = 360
    
    // The list of shuttles should be sorted by distance from user
    // TODO: Account for drawer when adjusting camera using GeometryReader
    
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
        GeometryReaderSheetWrapperView(height: $currentSheetHeight, shouldUpdate: nestedSheetLevel == 0) {
            RouteListContentView()
                .sheet(isPresented: .constant(globalDataState.selectedRouteId != nil) ) {
                    GeometryReaderSheetWrapperView(height: $currentSheetHeight, shouldUpdate: nestedSheetLevel == 1) {
                        RouteInfoContentView()
                            .sheet(isPresented: .constant(globalDataState.selectedShuttleId != nil)) {
                                GeometryReaderSheetWrapperView(height: $currentSheetHeight, shouldUpdate: nestedSheetLevel == 2) {
                                    ShuttleInfoContentView()
                                        .sheetViewModifier(showSheet: nestedSheetLevel == 2)
                                }
                            }
                            .sheetViewModifier(showSheet: nestedSheetLevel == 1)
                    }
                }
                .sheet(isPresented: .constant(globalDataState.selectedShuttleId != nil && globalDataState.selectedRouteId == nil)) {
                    GeometryReaderSheetWrapperView(height: $currentSheetHeight, shouldUpdate: nestedSheetLevel == 1) {
                        ShuttleInfoContentView()
                            .sheetViewModifier(showSheet: nestedSheetLevel == 1)
                    }
                }
                .sheetViewModifier(showSheet: nestedSheetLevel == 0)
        }
    }
}

#Preview {
    return ContentView()
        .environmentObject(GlobalDataState())
        .environmentObject(LocationManagerState())
}
