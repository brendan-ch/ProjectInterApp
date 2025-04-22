//
//  GlobalDataModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

import Foundation

class GlobalDataModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = GlobalIdSelectionModel
    
    func build() -> GlobalIdSelectionModel {
        let model = GlobalIdSelectionModel()
        model.systems = [
            System(name: "Chapman University", id: "1"),
            System(name: "City of Monterey Park", id: "2")
        ]
        
        return model
    }
}
