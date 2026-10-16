//
//  WithInitializationView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.08.
//

import SwiftUI

enum InitializationState {
    case notInitialized
    case initializing
    case succeeded
    case failed
}

struct WithInitializationView<Content: View>: View {
    let dataInitState: InitializationState
    @ViewBuilder let content: Content
    
    var body: some View {
        switch dataInitState {
        case .initializing:
            ProgressView()
                .padding()
        case .succeeded:
            content
        case .failed:
            Text("Failed to load content. Please try again later.")
                .padding()
        default:
            ProgressView()
                .padding()
        }
    }
}

