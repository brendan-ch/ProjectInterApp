//
//  GlobalDataModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

import Foundation

class GlobalIdSelectionModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = GlobalIdSelectionModel
    
    func build() -> GlobalIdSelectionModel {
        let model = GlobalIdSelectionModel()
        
        return model
    }
}
