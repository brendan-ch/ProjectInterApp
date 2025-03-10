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

/// View which wraps the passed sheet view with a `GeometryReader`,
/// reporting height changes through a binding.
struct GeometryReaderSheetWrapperView<Content: View>: View {
    /// The height of the given sheet.
    @Binding var height: CGFloat
    
    /// Controls whether the view should pass updates to the binding.
    var shouldUpdate: Bool
    
    /// The content to display within the `GeometryReader`.
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

/// The primary view of the app. Controls map height adjustment and
/// which sheet is displayed.
struct ContentView: View {
    /// Whether the root-level sheet should be showing.
    @State var showSheet = false
    
    @EnvironmentObject var globalDataState: GlobalDataModel
    @EnvironmentObject var locationManagerState: GlobalLocationDataModel
    
    /// Nesting level of the currently displayed sheet.
    /// Determines which sheet propogates updates to ``currentSheetHeight``
    /// and the presentation detent level.
    var nestedSheetLevel: Int {
        if globalDataState.selectedRouteId != nil && globalDataState.selectedShuttleId != nil {
            return 2
        } else if globalDataState.selectedRouteId != nil || globalDataState.selectedShuttleId != nil {
            return 1
        }
        return 0
    }
    
    /// The height of the currently displayed sheet.
    /// Used to adjust the nested ``MapView`` height.
    @State var currentSheetHeight: CGFloat = 360
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
//                MapView()
                NewMapView()
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
        .environmentObject(GlobalDataModel())
        .environmentObject(GlobalStopsModel())
        .environmentObject(GlobalLocationDataModel())
}
