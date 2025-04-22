//
//  GlobalSystemsModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

class GlobalSystemsModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = GlobalSystemsModel
    
    func build() -> GlobalSystemsModel {
        let model = GlobalSystemsModel()
        model.systems = [
            System(name: "Chapman University", id: "1"),
            System(name: "City of Monterey Park", id: "2")
        ]
        
        return model
    }
}
