//
//  DataWrapperView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.06.21.
//

import SwiftUI

/// View which conditionally renders a message if there is no data available.
/// Ensures consistent "no data" message across all data views.
struct DataWrapperView<Content: View>: View {
    var shouldDisplayNoDataMessage: Bool
    var noDataMessage: String
    
    @ViewBuilder let dataView: Content
    
    var body: some View {
        if (shouldDisplayNoDataMessage) {
            // In the future, try to enforce more consistent root sheet styling so that this
            // results in the same behavior
            Spacer()
            Text(noDataMessage)
                .foregroundStyle(.secondary)
            Spacer()
        } else {
            dataView
        }
    }
}
