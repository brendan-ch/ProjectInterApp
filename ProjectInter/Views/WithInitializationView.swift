//
//  WithInitializationView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.08.
//

import SwiftUI

struct WithInitializationView<Content: View>: View {
    let dataInitState: InitializationState
    @ViewBuilder let content: Content
    
    var body: some View {
        switch dataInitState {
        case .initializing:
            Text("Loading content")
        case .succeeded:
            content
        case .failed:
            Text("Failed to load content. Please try again later.")
        default:
            Text("Loading content")
        }
    }
}

