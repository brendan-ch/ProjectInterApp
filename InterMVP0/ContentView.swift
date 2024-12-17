//
//  ContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import MapKit

extension MKCoordinateRegion {
    static let anaheim = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.79787, longitude: -117.8937), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}

struct ContentView: View {
    @State private var region: MKCoordinateRegion = .anaheim
    @State var showSheet = false
    @State var showingNestedSheet = false
    
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedResult: MKMapItem?
    
    let shuttles = [
        Shuttle(currentLatitude: 33.79964, currentLongitude: -117.89328, label: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away"),
        Shuttle(currentLatitude: 33.78788, currentLongitude: -117.85921, label: "Teal Shuttle 12", estimatedTimeAwayDisplay: "5 min away")
    ]
    
    var shuttleMapItems: [MKMapItem] {
        var mapItems: [MKMapItem] = []
        for shuttle in shuttles {
            let newMapItem = MKMapItem(
                placemark: .init(
                    coordinate: .init(latitude: shuttle.currentLatitude, longitude: shuttle.currentLongitude)
                )
            )
            newMapItem.name = shuttle.label
            mapItems.append(newMapItem)
        }
        return mapItems
    }
    
    // The list of shuttles should be sorted by distance from user
    // TODO: Account for drawer when adjusting camera using GeometryReader
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                Map(position: $position, selection: $selectedResult) {
                    UserAnnotation()
                    
//                    ForEach(shuttles) { shuttle in
//                        Marker(shuttle.label, systemImage: "bus", coordinate: CLLocationCoordinate2D(latitude: shuttle.currentLatitude, longitude: shuttle.currentLongitude))
//                            .tint(.blue)
//                    }
                    
                    ForEach(shuttleMapItems, id: \.self) { mapItem in
                        Marker(item: mapItem)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            ShuttleListContentView(isPresented: $showSheet, isShowingNestedSheet: $showingNestedSheet, shuttles: shuttles)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .presentationDetents([.height(110), .height(360), .large], selection: showingNestedSheet ? .constant(.height(110)) : .constant(.height(360)))
                .presentationBackground(.regularMaterial)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    ContentView()
}
