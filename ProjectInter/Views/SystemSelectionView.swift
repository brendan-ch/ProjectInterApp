//
//  SystemSelectionView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

import SwiftUI

struct SystemSelectionView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                Button {
                    
                } label: {
                    Text("Chapman University")
                }
                .tint(Color.primary)
            }
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: Text("Search for a system")
            )
        }
    }
}

#Preview {
    SystemSelectionView()
}
