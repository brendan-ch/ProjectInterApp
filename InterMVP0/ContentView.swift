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

struct ContentView: View {
    @State private var region: MKCoordinateRegion = .anaheim
    @State var showSheet = false
    @State var showingNestedSheet = false
    @State var showingShuttleInfoSheet = false
    
    @State private var position: MapCameraPosition = .automatic
    
    @StateObject var mapSelectionState = MapSelectionState()
    
    @Query var shuttles: [Shuttle]
    @Query var routes: [MockRoute]

    let sampleRoute: [CLLocationCoordinate2D] = [
        // 33.79326° N, 117.85298° W
        CLLocationCoordinate2D(latitude: 33.79326, longitude: -117.85298),
        // 33.79331° N, 117.85638° W
        CLLocationCoordinate2D(latitude: 33.79331, longitude: -117.85638),
        // 33.78791° N, 117.85639° W
        CLLocationCoordinate2D(latitude: 33.78791, longitude: -117.85638),
        // 33.78793° N, 117.88079° W
        CLLocationCoordinate2D(latitude: 33.78793, longitude: -117.88079),
        // 33.78800° N, 117.88347° W
        CLLocationCoordinate2D(latitude: 33.78800, longitude: -117.88347),
    ]
    
    // The list of shuttles should be sorted by distance from user
    // TODO: Account for drawer when adjusting camera using GeometryReader
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                Map(position: $position, selection: $mapSelectionState.selectedShuttle) {
                    UserAnnotation()
                    
                    ForEach(shuttles) { shuttle in
                        Annotation(shuttle.label, coordinate: CLLocationCoordinate2D(latitude: shuttle.currentLatitude, longitude: shuttle.currentLongitude), anchor: .center) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(hex: shuttle.route?.colorHex ?? "#000000"))
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(.background, lineWidth: 4)
                                Image(systemName: "bus.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .padding(6)
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .annotationTitles(mapSelectionState.selectedShuttle == shuttle ? .visible : .hidden)
                        .tag(shuttle)
                    }
                    
                    MapPolyline(coordinates: sampleRoute)
                        .stroke(.red, lineWidth: 5)
                }
            }
        }
        .task {
            showSheet = true
        }
        .onChange(of: mapSelectionState.selectedShuttle) {
            guard mapSelectionState.selectedShuttle != nil else { return }
            
            if !showingNestedSheet {
                showingShuttleInfoSheet = true
            }
        }
        .sheet(isPresented: $showSheet) {
            RouteListContentView(routes: routes, isPresented: $showSheet, isShowingNestedSheet: $showingNestedSheet, showingShuttleInfoSheet: $showingShuttleInfoSheet)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .presentationDetents([.height(110), .height(360), .large], selection: showingNestedSheet ? .constant(.height(110)) : .constant(.height(360)))
                .presentationBackground(.regularMaterial)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
        .environmentObject(mapSelectionState)
    }
}

#Preview {
    let schema = Schema([
        Shuttle.self,
        MockRoute.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    let previewContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)

    // TODO: reuse mock data logic from InterMVP0App
    let route = MockRoute(label: "Red Route", callout: "towards Chapman Grand", colorHex: "#db2316", timeEstimates: "5, 15 min")

    let upcomingDepartures = [
        Shuttle(currentLatitude: 33.79964, currentLongitude: -117.89328, label: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away"),
        Shuttle(currentLatitude: 33.78788, currentLongitude: -117.85921, label: "Red Shuttle 25", estimatedTimeAwayDisplay: "15 min away")
    ]
    
    for upcomingDeparture in upcomingDepartures {
        previewContainer.mainContext.insert(upcomingDeparture)
    }
    
    route.shuttles = upcomingDepartures
    
    previewContainer.mainContext.insert(route)
    
    return ContentView()
        .modelContainer(previewContainer)
}
