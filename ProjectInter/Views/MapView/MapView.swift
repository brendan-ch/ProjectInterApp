//
//  MapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.11.
//

import SwiftUI

/// SwiftUI wrapper for the UIKit map view which manages the view model.
/// The networking logic is much easier to handle in SwiftUI, so we just let
/// UIKit take care of the rendering aspect.
struct MapView: View {
    @EnvironmentObject var globalDataState: GlobalDataModel
    @StateObject var viewModel = MapViewModel()
    
    var layoutMarginBottomValue: CGFloat = 0
    
    var mapViewNetworkArguments: MapViewNetworkArguments? {
        guard let systemId = globalDataState.selectedSystem?.id else { return nil }
        
        return MapViewNetworkArguments(systemId: systemId)
    }
    
    var body: some View {
        MapViewRepresentable(layoutMarginBottomValue: layoutMarginBottomValue)
            .ignoresSafeArea()
            .environmentObject(viewModel)
            .onAppear {
                if let client = globalDataState.apolloClient {
                    viewModel.apolloClient = client
                }
                
                restartDataUpdatesIfArgumentsExist()
            }
            .onChange(of: globalDataState.selectedSystem) {
                restartDataUpdatesIfArgumentsExist()
            }
    }
    
    private func restartDataUpdatesIfArgumentsExist() {
        if let arguments = mapViewNetworkArguments {
            viewModel.stopRefreshingData()
            viewModel.startRefreshingData(arguments: arguments)
        }
    }
}
