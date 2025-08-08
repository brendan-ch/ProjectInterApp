//
//  RouteInfoContentViewModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

import Foundation

class RouteInfoContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = RouteInfoContentViewModel
    
    func build() -> RouteInfoContentViewModel {
        let newModel = RouteInfoContentViewModel()
        Task {
            DispatchQueue.main.sync {
                newModel.dataInitState = .initializing
            }
            try? await Task.sleep(for: .seconds(2))
            
            DispatchQueue.main.sync {
                newModel.dataInitState = .succeeded
                newModel.routeName = "Red Route"
                newModel.routeNextStopName = "Chapman Grand"
                
                newModel.shuttles = [
                    RouteInfoContentViewShuttle(name: "Red Shuttle 17", secondsRemaining: 20, id: "1"),
                    RouteInfoContentViewShuttle(name: "Red Shuttle 5", secondsRemaining: 120, id: "2"),
                ]
                
            }
        }
        
        return newModel
    }
}
