//
//  RouteListContentViewModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

import Foundation

class RouteListContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = RouteListContentViewModel
    
    func build() -> RouteListContentViewModel {
        let newModel = RouteListContentViewModel()
        
        newModel.routes = [
            RouteListContentViewRoute(
                id: "1",
                name: "Red Route",
                colorHex: "#db2316",
                nextStopName: "Chapman Grand",
                etasInSeconds: [480, 720]
            ),
            RouteListContentViewRoute(
                id: "2",
                name: "Teal Route",
                colorHex: "#21bdd1",
                nextStopName: "Panther Village",
                etasInSeconds: [300, 900]
            ),
        ]
        
        return newModel
    }
}
