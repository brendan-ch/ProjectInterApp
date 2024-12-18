//
//  ShuttleListContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

struct ShuttleListContentView: View {
    @Binding var isPresented: Bool
    @Binding var isShowingNestedSheet: Bool
    
    // Probably going to make this into a binding eventually
    @State private var selectedShuttle: Shuttle?

    var shuttles: [Shuttle]
    
    var otherShuttles: ArraySlice<Shuttle> {
        return shuttles[1...]
    }
    
    var body: some View {
        List {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Shuttles")
                        .font(.title2)
                        .bold()
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding()

            Section(header: Text("Nearby")) {
                if (!shuttles.isEmpty) {
                    ShuttleListItem(shuttle: shuttles[0]) { shuttle in
                        isShowingNestedSheet = true
                        selectedShuttle = shuttle
                    }
//                    Button(action: {
//                        isShowingNestedSheet = true
//                    }) {
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text("Red Shuttle")
//                                    .bold()
//                                Text("5 min. away")
//                                    .font(.callout)
//                                    .foregroundStyle(.secondary)
//                            }
//                            .padding(.vertical)
//                            Spacer()
//                        }
//                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal)

            Section(header: Text("Other")) {
                ForEach(otherShuttles) { otherShuttle in
                    ShuttleListItem(shuttle: otherShuttle) { shuttle in
                        isShowingNestedSheet = true
                        selectedShuttle = shuttle
                    }
                }
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("Teal Shuttle")
//                            .bold()
//                        Text("15 min. away")
//                            .font(.callout)
//                            .foregroundStyle(.secondary)
//                    }
//                    .padding(.vertical)
//                    Spacer()
//                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal)
        }
        .listStyle(.plain)
        .background(Color.clear)
        .sheet(isPresented: $isShowingNestedSheet) {
            if let selectedShuttle {
                ShuttleInfoContentView(isShowing: $isShowingNestedSheet, shuttle: selectedShuttle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .presentationDetents([.height(210), .height(360), .large])
                    .presentationBackground(.regularMaterial)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
        }
    }
}

struct ShuttleListItem: View {
    var shuttle: Shuttle
    var action: (_ selectedShuttle: Shuttle) -> Void
    
    var body: some View {
        Button {
            action(shuttle)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(shuttle.label)
                        .bold()
                    Text(shuttle.estimatedTimeAwayDisplay)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
        }
    }
}

let shuttles = [
    Shuttle(currentLatitude: 33.79964, currentLongitude: -117.89328, label: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away"),
    Shuttle(currentLatitude: 33.78788, currentLongitude: -117.85921, label: "Teal Shuttle 12", estimatedTimeAwayDisplay: "10 min away")
]

#Preview {
    ShuttleListContentView(isPresented: .constant(true), isShowingNestedSheet: .constant(false), shuttles: shuttles)
}
