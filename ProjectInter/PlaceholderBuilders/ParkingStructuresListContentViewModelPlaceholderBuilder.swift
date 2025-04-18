//
//  ParkingStructuresListContentViewModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

class ParkingStructuresListContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = ParkingStructuresListContentViewModel
    
    func build() -> ParkingStructuresListContentViewModel {
        let viewModel = ParkingStructuresListContentViewModel()
        viewModel.structures = [
            .init(
                spotsAvailable: 680,
                capacity: 871,
                name: "Anderson Structure",
                id: "1"
            ),
            .init(
                spotsAvailable: 425,
                capacity: 692,
                name: "Barrera",
                id: "2"
            )
        ]
        
        return viewModel
    }
    
}
