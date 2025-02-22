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
    
    @EnvironmentObject var globalDataModel: GlobalDataModel
    
    var searchResults: [Stop] {
        if searchText.isEmpty {
            return globalStopsModel.stops
        } else {
            return globalStopsModel.stops.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { stop in
                    Button {
                        globalStopsModel.selectedStop = stop
                        dismiss()
                    } label: {
                        Text(stop.name)
                    }
                    .tint(Color.primary)
                }
                
                if searchResults.isEmpty {
                    Text("No stops found.")
                }
            }
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: Text("Search for a stop")
            )
        }
        .task {
            guard let systemId = globalDataModel.selectedSystem?.id else { return }
            
            let stopsNetworkArguments = GlobalStopsNetworkArguments(
                systemId: systemId
            )
            await globalStopsModel.refreshDataOnce(arguments: stopsNetworkArguments)
        }
    }
}

#Preview {
    let builder = GlobalStopsModelPlaceholderBuilder()
    let globalStopsModel = builder.build()
    
    StopSelectionView()
        .environmentObject(globalStopsModel)
        .environmentObject(GlobalDataModelPlaceholderBuilder().build())
}
