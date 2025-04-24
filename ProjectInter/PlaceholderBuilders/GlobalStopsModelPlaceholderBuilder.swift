//
//  GlobalStopsModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

class GlobalStopsModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = GlobalStopsModel
    
    func build() -> GlobalStopsModel {
        let newModel = GlobalStopsModel()
        
        newModel.stops = [
            GlobalStopsModelStop(name: "Chapman Court", id: "1", coordinates: RawCoordinates(latitude: 33.796796, longitude: -117.889293)),
            GlobalStopsModelStop(name: "Schmid Gate", id: "2", coordinates: RawCoordinates(latitude: 33.793292, longitude: -117.852904))
        ]
        newModel.selectStopId(newModel.stops.first!.id)
        
        return newModel
    }
}

