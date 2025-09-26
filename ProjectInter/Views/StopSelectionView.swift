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
    
    @Environment(GlobalStopsModel.self) var globalStopsModel: GlobalStopsModel
    
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    
    @Environment(LocationDataModel.self) var locationModel: LocationDataModel
    
    @Environment(\.dismiss) var dismiss
    
    var searchResults: [GlobalStopsModelStop] {
        if searchText.isEmpty {
            return globalStopsModel.stops
        } else {
            return globalStopsModel.stops.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        automaticallySelectStop()
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "location.fill")
                            
                            if locationModel.isAuthorized {
                                Text("Automatic")
                            } else {
                                Text("No location access")
                            }
                        }
                    }
                    .tint(Color.primary)
                    .disabled(!locationModel.isAuthorized)
                }
                Section(header: Text("All stops")) {
                    ForEach(searchResults) { stop in
                        Button {
                            globalStopsModel.selectStopId(stop.id)
                            dismiss()
                        } label: {
                            Text(stop.name)
                                .accessibilityIdentifier("StopSelectionCollectionSearchResultItem \(stop.id)")
                        }
                        .tint(Color.primary)
                    }
                    
                    if searchResults.isEmpty {
                        Text("No stops found.")
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: Text("Search for a stop")
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
        .task {
            guard let systemId = globalSystemsModel.selectedSystem?.id else { return }
            
            let stopsNetworkArguments = GlobalStopsNetworkArguments(
                systemId: systemId
            )
            await globalStopsModel.refreshDataOnce(arguments: stopsNetworkArguments)
        }
    }
    
    func automaticallySelectStop() {
        if let location = locationModel.lastUpdatedLocation {
            globalStopsModel.automaticallySelectStop(for: location)
        } else {
            globalStopsModel.automaticallySelectStop()
        }
    }
}

#Preview {
    let globalStopsModel = GlobalStopsModel.buildPlaceholder()
    
    StopSelectionView()
        .environment(globalStopsModel)
        .environment(GlobalSystemsModel.buildPlaceholder())
        .environment(LocationDataModel())
}
