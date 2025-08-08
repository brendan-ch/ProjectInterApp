//
//  ParkingStructureInfoPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.07.
//

import Foundation

class ParkingStructureInfoContentViewModelPlaceholderBuilder: PlaceholderBuilderProtocol {
    let calendar = Calendar.current
    let now = Date()
    
    typealias PlaceholderType = ParkingStructureInfoContentViewModel
    
    func build() -> ParkingStructureInfoContentViewModel {
        let data: [ParkingAveragePerTimePeriod] = [
            .init(
                from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 50
            ),
            .init(
                from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 28
            ),
            .init(
                from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 15
            ),
            .init(
                from: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 17
            ),
            .init(
                from: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 21
            ),
            .init(
                from: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 47
            ),
            .init(
                from: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!,
                to: calendar.date(bySettingHour: 22, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 76
            )
        ]
        
        let viewModel = ParkingStructureInfoContentViewModel()
        
        Task {
            DispatchQueue.main.sync {
                viewModel.dataInitState = .initializing
            }
            try? await Task.sleep(for: .seconds(2))
            
            DispatchQueue.main.sync {
                viewModel.dataInitState = .succeeded
                viewModel.name = "Anderson Structure"
                viewModel.capacity = 100
                viewModel.spotsAvailable = 80
                viewModel.averages = data
            }

        }
        
        return viewModel
    }
}
