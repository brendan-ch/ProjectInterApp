//
//  ContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var showSheet = false
    @State var showingNestedSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                Map(coordinateRegion: $region)
            }
        }
        .ignoresSafeArea()
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            ShuttleListContentView(isPresented: $showSheet, isShowingNestedSheet: $showingNestedSheet)
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
