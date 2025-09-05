//
//  SystemSelectionView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

import SwiftUI

struct SystemSelectionView: View {
    @State private var searchText = ""
    
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    
    @Environment(\.dismiss) var dismiss

    var searchResults: [System] {
        if searchText.isEmpty {
            return globalSystemsModel.systems
        } else {
            return globalSystemsModel.systems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { system in
                    Button {
                        globalSystemsModel.selectSystemId(system.id)
                        dismiss()
                    } label: {
                        Text(system.name)
                            .accessibilityIdentifier("SystemSelectionCollectionSearchResultItem \(system.id)")
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
    var globalDataModel = GlobalSystemsModel.buildPlaceholder()
    
    SystemSelectionView()
        .environment(globalDataModel)
}
