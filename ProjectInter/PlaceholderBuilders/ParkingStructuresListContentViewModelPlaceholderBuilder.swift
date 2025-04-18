//
//  ParkingStructuresListContentViewModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

class ParkingStructuresListContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    typealias PlaceholderType = ParkingStructuresListContentViewModel
    
    func build() -> ParkingStructuresListContentViewModel {
        var viewModel = ParkingStructuresListContentViewModel()
        viewModel.structures = [
            .init(
                address: "300 E Walnut, Orange, CA 92867",
                spotsAvailable: 680,
                capacity: 871,
                coordinates: .init(latitude: 33.7945513, longitude: -117.8518707),
                name: "Anderson Structure",
                id: "1"
            ),
            .init(
                address: "200 W Sycamore Ave, Orange, CA 92866-105",
                spotsAvailable: 425,
                capacity: 692,
                coordinates: .init(latitude: 33.792937, longitude: -117.854782),
                name: "Barrera",
                id: "2"
            )
        ]
        
        return viewModel
    }
    
}
