//
//  ParkingStructureInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.06.
//

import Foundation
import Apollo
import ProjectInterOperations

// MARK: - Models

struct ParkingAveragePerTimePeriod {
    let from: Date
    let to: Date
    let averageSpotsAvailable: Float
    var averageSpotsAvailableRounded: Int {
        Int(self.averageSpotsAvailable.rounded())
    }
}

extension ParkingAveragePerTimePeriod {
    init(_ average: GetParkingStructureInfoDataQuery.Data.System.ParkingSystem.ParkingStructure.HistoricalAverage) {
        from = average.from
        to = average.to
        averageSpotsAvailable = Float(average.averageSpotsAvailable)
    }
}

struct ParkingStructureNetworkingArguments {
    let systemId: String
    let parkingStructureId: String
}

// MARK: - View model implementation

extension ParkingStructureInfoContentView {
    @Observable
    class ViewModel: NetworkDataModelProtocol {
        // MARK: Constants
        static let startingHour = 8
        static let endingHour = 20
        static let intervalHours = 2
        static let intervalMs = 1000 * 60 * 60 * intervalHours
        
        private let calendar: Calendar
        
        // MARK: Unique properties
        
        var name: String?
        var capacity: Int?
        var spotsAvailable: Int?
        var address: String?
        
        var averages: [ParkingAveragePerTimePeriod]?
        var currentDayAverages: [ParkingAveragePerTimePeriod]?
        
        var startOfCurrentTimePeriod: Date?
        var endOfCurrentTimePeriod: Date?
        
        var parkingInsight: String? {
            guard let name = name,
                  let spotsAvailable = spotsAvailable,
                  let capacity = capacity,
                  let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: referenceDate),
                  let average = findAverageCorrespondingToDate(oneWeekAgo) else {
                return nil
            }
            
            // Avoid division by 0
            let averageFilledSpots = capacity - average.averageSpotsAvailableRounded
            if averageFilledSpots == 0 {
                return nil
            }
            
            let percentage = (Double(capacity - spotsAvailable) / Double(averageFilledSpots)) * 100 - 100
            let roundedPercentage = Int(percentage.rounded())
            if roundedPercentage == 0 {
                return "\(name) was also around this filled last week."
            }
            if roundedPercentage < 0 {
                return "\(name) is currently \(-roundedPercentage)% less filled compared to this time last week."
            }
            
            return "\(name) is currently \(roundedPercentage)% more filled compared to this time last week."
        }
        
        /// Can be initialized during testing to replace the "current" point in time.
        private let fixedReferenceDate: Date?
        
        var referenceDate: Date {
            if let referenceDate = fixedReferenceDate {
                return referenceDate
            }
            return Date()
        }
        
        var oneWeekAgo: Date? {
            if let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: referenceDate) {
                return oneWeekAgo
            }
            return nil
        }
        
        // MARK: Conformance to protocol
        
        @Published var dataInitState: InitializationState = .notInitialized
        
        typealias NetworkArguments = ParkingStructureNetworkingArguments
        
        var dataRefreshLoopTask: Task<Void, any Error>?
        
        var apolloNetworkModel: ApolloNetworkModel?
        
        required init(apolloNetworkModel: ApolloNetworkModel? = nil) {
            self.apolloNetworkModel = apolloNetworkModel
            self.calendar = .current
            self.fixedReferenceDate = nil
        }
        
        init(apolloNetworkModel: ApolloNetworkModel? = nil, referenceDate: Date) {
            self.apolloNetworkModel = apolloNetworkModel
            self.calendar = .current
            self.fixedReferenceDate = referenceDate
        }
        
        private func setStartAndEndPeriodForCurrentCorrespondingAverage() {
            guard let oneWeekAgo = oneWeekAgo,
                  let average = findAverageCorrespondingToDate(oneWeekAgo) else {
                return
            }
            
            let numSecondsDiff: TimeInterval = 1
            startOfCurrentTimePeriod = average.from - numSecondsDiff
            endOfCurrentTimePeriod = average.to
        }
        
        func findAverageCorrespondingToDate(_ date: Date) -> ParkingAveragePerTimePeriod? {
            guard let averages = averages else {
                return nil
            }
            
            for average in averages {
                if average.from <= date && average.to >= date {
                    return average
                }
            }
            
            return nil
        }
        
        func generateHistoricalAverageInput(for date: Date) -> HistoricalParkingAverageQueryInput? {
            let from = calendar.date(bySettingHour: ViewModel.startingHour, minute: 0, second: 0, of: date)!
            let to = calendar.date(bySettingHour: ViewModel.endingHour, minute: 0, second: 0, of: date)!
            
            let historicalAverageInput = HistoricalParkingAverageQueryInput(
                from: from,
                to: to,
                // Every 2 hours
                intervalMs: ViewModel.intervalMs
            )
            return historicalAverageInput
        }
        
        func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GetParkingStructureInfoDataQuery {
            let historicalAverageInput = generateHistoricalAverageInput(for: oneWeekAgo!)
            return GetParkingStructureInfoDataQuery(
                systemId: arguments.systemId,
                parkingStructureId: arguments.parkingStructureId,
                historicalAveragesInput: historicalAverageInput!)
        }
        
        func processRefreshDataResult(_ result: Result<GetParkingStructureInfoDataQuery.Data, any Error>) {
            switch result {
            case .failure(let error):
                Loggers.shared.networkingLogger.log("Failed to fetch parking structure info: \(error)")
            case .success(let result):
                guard let parkingStructure = result.system?.parkingSystem?.parkingStructure else {
                    clearAllData()
                    return
                }
                
                name = parkingStructure.name
                capacity = parkingStructure.capacity
                spotsAvailable = parkingStructure.spotsAvailable
                address = parkingStructure.address
                
                guard let averagesFromNetwork = parkingStructure.historicalAverages else {
                    clearHistoricalData()
                    return
                }
                
                averages = averagesFromNetwork.map(ParkingAveragePerTimePeriod.init)
                setStartAndEndPeriodForCurrentCorrespondingAverage()
            }
        }
        
        // Until we design a better way to handle multiple GraphQL queries,
        // this solution keeps things testable
        func loadCurrentDayHistorical(_ arguments: NetworkArguments) async {
            let historicalAverageInput = generateHistoricalAverageInput(for: referenceDate)
            let query = GetParkingStructureInfoDataQuery(
                systemId: arguments.systemId,
                parkingStructureId: arguments.parkingStructureId,
                historicalAveragesInput: historicalAverageInput!)
            
            guard let result = try? await apolloNetworkModel?.fetchOnce(query),
                  let averagesFromNetwork = result.data?.system?.parkingSystem?.parkingStructure?.historicalAverages else {
                return
            }
            
            await MainActor.run {
                var averages: [ParkingAveragePerTimePeriod] = []
                for averageFromNetwork in averagesFromNetwork {
                    let from = calendar.date(byAdding: .day, value: -7, to: averageFromNetwork.from)!
                    let to = calendar.date(byAdding: .day, value: -7, to: averageFromNetwork.to)!
                    let average = ParkingAveragePerTimePeriod(
                        from: from,
                        to: to,
                        averageSpotsAvailable: Float(averageFromNetwork.averageSpotsAvailable),
                    )
                    
                    averages.append(average)
                }
                
                currentDayAverages = averages
            }
        }
        
        private func clearAllData() {
            name = nil
            capacity = nil
            spotsAvailable = nil
            
            clearHistoricalData()
        }
        
        private func clearHistoricalData() {
            averages = nil
            startOfCurrentTimePeriod = nil
            endOfCurrentTimePeriod = nil
        }
        
        
    }
}

