//
//  ParkingStructuresListContentViewModelPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import Foundation

extension ParkingStructuresListContentView {
    class PlaceholderBuilder: PlaceholderBuilderProtocol {
        typealias PlaceholderType = ViewModel
        
        func build() -> ViewModel {
            let viewModel = ViewModel()
            
            Task {
                DispatchQueue.main.sync {
                    viewModel.dataInitState = .initializing
                }
                try? await Task.sleep(for: .seconds(2))
                DispatchQueue.main.sync {
                    viewModel.dataInitState = .succeeded
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
                }
            }
            
            return viewModel
        }
        
    }
}
