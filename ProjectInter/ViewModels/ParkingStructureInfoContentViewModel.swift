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

class ParkingStructureInfoContentViewModel: NetworkDataModelProtocol {
    @Published var name: String?
    @Published var capacity: Int?
    @Published var spotsAvailable: Int?
    
    @Published var averages: [ParkingAveragePerTimePeriod]?
    
    private let calendar = Calendar.current
    
    typealias NetworkArguments = ParkingStructureNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloClient: (any Apollo.ApolloClientProtocol)?
    
    required init(apolloClient: (any Apollo.ApolloClientProtocol)?) {
        self.apolloClient = apolloClient
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GetParkingStructureInfoDataQuery {
        let from = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        let to = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
        
        let historicalAverageInput = HistoricalParkingAverageQueryInput(
            from: from,
            to: to,
            // Every 2 hours
            intervalMs: 1000 * 60 * 60 * 2
        )
        
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
