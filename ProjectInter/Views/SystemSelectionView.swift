//
//  SystemSelectionView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

import SwiftUI

struct SystemSelectionView: View {
    @State private var searchText = ""
    
    @EnvironmentObject var globalDataModel: GlobalIdSelectionModel
    
    @Environment(\.dismiss) var dismiss

    var searchResults: [System] {
        if searchText.isEmpty {
            return globalDataModel.systems
        } else {
            return globalDataModel.systems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { system in
                    Button {
                        globalDataModel.selectedSystem = system
                        dismiss()
                    } label: {
                        Text(system.name)
                    }
                    .tint(Color.primary)
                }
            }
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: Text("Search for a system")
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
    }
}

#Preview {
    var globalDataModelBuilder = GlobalDataModelPlaceholderBuilder()
    var globalDataModel = globalDataModelBuilder.build()
    
    SystemSelectionView()
        .environmentObject(globalDataModel)
}
