//
//  ParkingStructureInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.06.
//

import Apollo
import ProjectInterOperations

struct ParkingStructureNetworkingArguments {
    let systemId: String
    let parkingStructureId: String
}

class ParkingStructureInfoContentViewModel: NetworkDataModelProtocol {
    
    typealias NetworkArguments = ParkingStructureNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloClient: (any Apollo.ApolloClientProtocol)?
    
    required init(apolloClient: (any Apollo.ApolloClientProtocol)?) {
        self.apolloClient = apolloClient
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GetParkingStructureInfoDataQuery {
        let historicalAverageInput = HistoricalParkingAverageQueryInput(
            from: "",
            to: "",
            // Every 2 hours
            intervalMs: 1000 * 60 * 60 * 2
        )
        
        return GetParkingStructureInfoDataQuery(
            systemId: arguments.systemId,
            parkingStructureId: arguments.parkingStructureId,
            historicalAveragesInput: historicalAverageInput)
    }
    
    func processRefreshDataResult(_ result: Result<Apollo.GraphQLResult<ProjectInterOperations.GetParkingStructureInfoDataQuery.Data>, any Error>) {
        
    }
}
