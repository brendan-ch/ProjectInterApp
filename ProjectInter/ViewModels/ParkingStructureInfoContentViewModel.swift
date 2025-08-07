//
//  ParkingStructureInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.06.
//

import Foundation
import Apollo
import ProjectInterOperations

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

class ParkingStructureInfoContentViewModel: NetworkDataModelProtocol {
    @Published var name: String?
    @Published var capacity: Int?
    @Published var spotsAvailable: Int?
    
    @Published var averages: [ParkingAveragePerTimePeriod]?
    
    // Historical average data
    static let startingHour = 8
    static let endingHour = 20
    static let intervalMs = 1000 * 60 * 60 * 2
    
    private let calendar = Calendar.current
    
    typealias NetworkArguments = ParkingStructureNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloClient: (any Apollo.ApolloClientProtocol)?
    
    required init(apolloClient: (any Apollo.ApolloClientProtocol)? = nil) {
        self.apolloClient = apolloClient
    }
    
    func generateHistoricalAverageInput() -> HistoricalParkingAverageQueryInput {
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        let from = calendar.date(bySettingHour: ParkingStructureInfoContentViewModel.startingHour, minute: 0, second: 0, of: oneWeekAgo)!
        let to = calendar.date(bySettingHour: ParkingStructureInfoContentViewModel.endingHour, minute: 0, second: 0, of: oneWeekAgo)!
        
        let historicalAverageInput = HistoricalParkingAverageQueryInput(
            from: from,
            to: to,
            // Every 2 hours
            intervalMs: ParkingStructureInfoContentViewModel.intervalMs
        )
        return historicalAverageInput
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GetParkingStructureInfoDataQuery {
        let historicalAverageInput = generateHistoricalAverageInput()
        return GetParkingStructureInfoDataQuery(
            systemId: arguments.systemId,
            parkingStructureId: arguments.parkingStructureId,
            historicalAveragesInput: historicalAverageInput)
    }
    
    func processRefreshDataResult(_ result: Result<Apollo.GraphQLResult<ProjectInterOperations.GetParkingStructureInfoDataQuery.Data>, any Error>) {
        switch result {
        case .failure(let error):
            Loggers.shared.networkingLogger.log("Failed to fetch parking structure info: \(error)")
        case .success(let result):
            guard let parkingStructure = result.data?.system?.parkingSystem?.parkingStructure else {
                clearAllData()
                return
            }
            
            name = parkingStructure.name
            capacity = parkingStructure.capacity
            spotsAvailable = parkingStructure.spotsAvailable
            
            guard let averagesFromNetwork = parkingStructure.historicalAverages else {
                clearHistoricalData()
                return
            }
            
            averages = averagesFromNetwork.map(ParkingAveragePerTimePeriod.init)
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
    }
}
