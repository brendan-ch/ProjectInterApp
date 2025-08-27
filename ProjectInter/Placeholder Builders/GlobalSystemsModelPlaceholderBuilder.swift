//
//  GlobalSystemsModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

import Foundation

class GlobalSystemsModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = GlobalSystemsModel
    
    func build() -> GlobalSystemsModel {
        let model = GlobalSystemsModel()
        
        Task {
            DispatchQueue.main.sync {
                model.dataInitState = .initializing
            }
            try? await Task.sleep(for: .seconds(2))
            
            DispatchQueue.main.sync {
                model.dataInitState = .succeeded
                model.systems = [
                    System(name: "Chapman University", id: "1"),
                    System(name: "City of Monterey Park", id: "2")
                ]
            }
        }
        
        return model
    }
}
