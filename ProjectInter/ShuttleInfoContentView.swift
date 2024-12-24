//
//  ShuttleInfoContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

struct ShuttleInfoContentView: View {
    @EnvironmentObject var mapSelectionState: MapSelectionState
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(mapSelectionState.selectedShuttle?.label ?? "")
                        .font(.title2)
                        .bold()
                    Text("Jacaranda St.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text(mapSelectionState.selectedShuttle?.estimatedTimeAwayDisplay ?? "")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("Last updated now")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Close") {
                    mapSelectionState.selectedShuttle = nil
                }
            }
            .padding()
            
            Button(action: {}) {
                HStack {
                    Spacer()
                    Image(systemName: "bell.badge")
                    Text("Notify me when nearby")
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
        }
    }
}

#Preview {
    let shuttle = Shuttle(currentLatitude: 33.79964, currentLongitude: -117.89328, label: "Red Shuttle 17", estimatedTimeAwayDisplay: "5 min away")
    
    let environmentObject = MapSelectionState()
    environmentObject.selectedShuttle = shuttle

    return ShuttleInfoContentView()
        .environmentObject(environmentObject)
}
