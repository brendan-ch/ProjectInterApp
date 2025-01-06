//
//  StopSelectionView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.06.
//

import SwiftUI

/// View which displays a list of stops for selection.
struct StopSelectionView: View {
    @State var searchText: String = ""
    
    @EnvironmentObject var globalStopsModel: GlobalStopsModel
    
    @Environment(\.dismiss) var dismiss
    
    var searchResults: [Stop] {
        if searchText.isEmpty {
            return globalStopsModel.stops
        } else {
            return globalStopsModel.stops.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(searchResults) { stop in
                    Button {
                        globalStopsModel.selectedStop = stop
                        dismiss()
                    } label: {
                        Text(stop.name)
                    }
                }
                
                if searchResults.isEmpty {
                    Text("No stops found.")
                }
            }
            .searchable(text: $searchText, placement: .automatic)
        }
    }
}

#Preview {
    let builder = GlobalStopsModelPlaceholderBuilder()
    let globalStopsModel = builder.build()
    
    StopSelectionView()
        .environmentObject(globalStopsModel)
}
