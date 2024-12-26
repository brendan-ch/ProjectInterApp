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
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(360), .large])
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
    }
}

extension View {
    func sheetViewModifier() -> some View {
        self.modifier(SheetViewModifier())
    }
}


struct ContentView: View {
    @State private var region: MKCoordinateRegion = .anaheim
    @State var showSheet = false
    
    @State private var position: MapCameraPosition = .automatic
    
    @StateObject var mapSelectionState = MapSelectionState()
    
//    @Query var shuttles: [Shuttle]
//    @Query var routes: [MockRoute]
//    
    var showingNestedSheet: Bool {
        mapSelectionState.selectedRoute != nil || mapSelectionState.selectedShuttle != nil
    }

    // The list of shuttles should be sorted by distance from user
    // TODO: Account for drawer when adjusting camera using GeometryReader
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
//                Map(position: $position, selection: $mapSelectionState.selectedShuttle) {
//                    UserAnnotation()
                    
//                    if let selectedRoute = mapSelectionState.routeToDisplay {
//                        ForEach(shuttles) { shuttle in
//                            if shuttle.route == selectedRoute {
//                                Annotation(shuttle.label, coordinate: CLLocationCoordinate2D(latitude: shuttle.currentLatitude, longitude: shuttle.currentLongitude), anchor: .center) {
//                                    ZStack {
//                                        RoundedRectangle(cornerRadius: 100)
//                                            .fill(Color(hex: shuttle.route?.colorHex ?? "#000000"))
//                                        RoundedRectangle(cornerRadius: 100)
//                                            .stroke(.background, lineWidth: 4)
//                                        Image(systemName: "bus.fill")
//                                            .resizable()
//                                            .frame(width: 16, height: 16)
//                                            .padding(6)
//                                            .foregroundStyle(Color.white)
//                                    }
//                                }
//                                .annotationTitles(mapSelectionState.selectedShuttle == shuttle ? .visible : .hidden)
//                                .tag(shuttle)
//                            }
//                        }
//                    } else {
//                        ForEach(shuttles) { shuttle in
//                            Annotation(shuttle.label, coordinate: CLLocationCoordinate2D(latitude: shuttle.currentLatitude, longitude: shuttle.currentLongitude), anchor: .center) {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 100)
//                                        .fill(Color(hex: shuttle.route?.colorHex ?? "#000000"))
//                                    RoundedRectangle(cornerRadius: 100)
//                                        .stroke(.background, lineWidth: 4)
//                                    Image(systemName: "bus.fill")
//                                        .resizable()
//                                        .frame(width: 16, height: 16)
//                                        .padding(6)
//                                        .foregroundStyle(Color.white)
//                                }
//                            }
//                            .annotationTitles(mapSelectionState.selectedShuttle == shuttle ? .visible : .hidden)
//                            .tag(shuttle)
//                        }
//                    }
//                    
//                    if let coordinates = mapSelectionState.coordinatesToDisplayForPolyline {
//                        MapPolyline(coordinates: coordinates)
//                            .stroke(.red, lineWidth: 5)
//                    }
//                }
//                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 360, trailing: 0))
            }
        }
        .task {
            showSheet = true
        }
//        .sheet(isPresented: $showSheet) {
//            sheetContent
//        }
//        .environmentObject(mapSelectionState)
    }
    
//    var sheetContent: some View {
//        RouteListContentView(routes: routes)
//            .sheet(isPresented: .constant(mapSelectionState.selectedRoute != nil) ) {
//                if mapSelectionState.selectedRoute != nil {
//                    RouteInfoContentView()
//                        .sheet(isPresented: .constant(mapSelectionState.selectedShuttle != nil)) {
//                            ShuttleInfoContentView()
//                                .sheetViewModifier()
//                        }
//                        .sheetViewModifier()
//                }
//            }
//            .sheet(isPresented: .constant(mapSelectionState.selectedShuttle != nil)) {
//                if mapSelectionState.selectedShuttle != nil {
//                    ShuttleInfoContentView()
//                        .sheetViewModifier()
//                }
//            }
//        .sheetViewModifier()
//        .presentationDetents([.height(359), .height(360), .large], selection: showingNestedSheet ? .constant(.height(359)) : .constant(.height(360)))
//    }
}

#Preview {
    return ContentView()
        .environmentObject(GlobalDataStateObject())
}
