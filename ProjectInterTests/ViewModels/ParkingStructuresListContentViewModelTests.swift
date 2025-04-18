//
//  ParkingStructuresListContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import Testing
@testable import ProjectInter
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

class ParkingStructuresListContentViewModelTestsMockData {
    static let defaultArguments = ParkingStructuresNetworkingArguments(systemId: "1")
    
    static let defaultMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructures: [
                    .init(
                        capacity: 100,
                        id: "1",
                        name: "Anderson Structure",
                        spotsAvailable: 50
                    ),
                    .init(
                        capacity: 200,
                        id: "2",
                        name: "Barrera",
                        spotsAvailable: 100
                    )
                ]
            )
        )
    )
    
    static let secondaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructures: [
                    .init(
                        capacity: 500,
                        id: "3",
                        name: "Knott Studios Lot",
                        spotsAvailable: 100
                    ),
                    .init(
                        capacity: 350,
                        id: "4",
                        name: "Jim Miller Lot",
                        spotsAvailable: 12
                    )
                ]
            )
        )
    )
}

// TODO: Implement Apollo initializer for ParkingStructuresListParkingStructure + tests

class ParkingStructuresListContentViewModelTests: NetworkDataModelTestsProtocol {
    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        
    }
    
    func startRefreshingDataRefreshesDataMultipleTimes() async {
        
    }
    
    func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        
    }
    
    func refreshDataOnceUpdatesData() async {
        
    }
    
    func refreshDataOnceDoesNothingIfNoData() async {
        
    }
    
    func refreshDataOnceDoesNothingIfNoApolloClient() async {
        
    }
    
    
}
