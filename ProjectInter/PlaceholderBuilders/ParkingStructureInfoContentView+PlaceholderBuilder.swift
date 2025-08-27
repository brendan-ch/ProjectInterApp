//
//  ParkingStructureInfoPlaceholderBuilder.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.07.
//

import Foundation

extension ParkingStructureInfoContentView {
    class PlaceholderBuilder: PlaceholderBuilderProtocol {
        let calendar = Calendar.current
        let now = Date()
        
        var oneWeekAgo: Date! {
            calendar.date(byAdding: .day, value: -7, to: now)!
        }
        
        typealias PlaceholderType = ViewModel
        
        func build() -> ViewModel {
            let data: [ParkingAveragePerTimePeriod] = [
                .init(
                    from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: oneWeekAgo)!,
                    to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: oneWeekAgo)!,
                    averageSpotsAvailable: 50
                ),
                .init(
                    from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: oneWeekAgo)!,
                    to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: oneWeekAgo)!,
                    averageSpotsAvailable: 28
                ),
                .init(
                    from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: oneWeekAgo)!,
                    to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: oneWeekAgo)!,
                    averageSpotsAvailable: 15
                ),
                .init(
                    from: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: oneWeekAgo)!,
                    to: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: oneWeekAgo)!,
                    averageSpotsAvailable: 17
                ),
                .init(
                    from: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: oneWeekAgo)!,
                    to: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: oneWeekAgo)!,
                    averageSpotsAvailable: 21
                ),
                .init(
                    from: calendar.date(bySettingHour: 18, minute: 0, second: 0, of: oneWeekAgo)!,
                    to: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: oneWeekAgo)!,
                    averageSpotsAvailable: 47
                ),
                .init(
                    from: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: oneWeekAgo)!,
                    to: calendar.date(bySettingHour: 22, minute: 0, second: 0, of: oneWeekAgo)!,
                    averageSpotsAvailable: 76
                )
            ]
            
            let viewModel = ViewModel()
            
            Task {
                DispatchQueue.main.sync {
                    viewModel.dataInitState = .initializing
                }
                try? await Task.sleep(for: .seconds(2))
                
                DispatchQueue.main.sync {
                    viewModel.dataInitState = .succeeded
                    viewModel.address = "300 E Walnut Ave, Orange, CA 92867 United States"
                    viewModel.name = "Anderson Structure"
                    viewModel.capacity = 100
                    viewModel.spotsAvailable = 80
                    viewModel.averages = data
                }
                
            }
            
            return viewModel
        }
    }
}
