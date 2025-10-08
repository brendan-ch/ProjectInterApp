//
//  ParkingStructuresListContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import Testing
@testable import ProjectInter
import ProjectInterOperations
import ProjectInterShared
import ApolloTestSupport
import ProjectInterTestMocks
import Foundation

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
    
    static let tertiaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: nil
        )
    )
}

// Test the extension that is declared in the view model file
class ParkingStructuresListParkingStructureTests {
    @Test func apolloDataInitializerInitializesData() {
        let data = GetParkingStructuresListDataQuery.Data.from(ParkingStructuresListContentViewModelTestsMockData.defaultMock)
        let parkingStructures = data.system!.parkingSystem!.parkingStructures!
        
        let constructedStructures = parkingStructures.map(ParkingStructure.init)
        
        for i in 0..<constructedStructures.count {
            #expect(constructedStructures[i].id == parkingStructures[i].id)
            #expect(constructedStructures[i].name == parkingStructures[i].name)
            #expect(constructedStructures[i].spotsAvailable == parkingStructures[i].spotsAvailable)
            #expect(constructedStructures[i].capacity == constructedStructures[i].capacity)
        }
    }
}

class ParkingStructuresListContentViewModelTests: NetworkDataModelTestsProtocol {
    let networkArguments = ParkingStructuresListContentViewModelTestsMockData.defaultArguments
    let defaultMock = ParkingStructuresListContentViewModelTestsMockData.defaultMock
    let secondaryMock = ParkingStructuresListContentViewModelTestsMockData.secondaryMock
    let tertiaryMock = ParkingStructuresListContentViewModelTestsMockData.tertiaryMock
    
    func assertViewModelDataForDefaultMock(viewModel: ParkingStructuresListContentView.ViewModel) {
        #expect(viewModel.structures.count == 2)
        
        #expect(viewModel.structures[0].id == "1")
        #expect(viewModel.structures[1].id == "2")
        
        #expect(viewModel.structures[0].capacity == 100)
        #expect(viewModel.structures[1].capacity == 200)
        
        #expect(viewModel.structures[0].name == "Anderson Structure")
        #expect(viewModel.structures[1].name == "Barrera")
        
        #expect(viewModel.structures[0].spotsAvailable == 50)
        #expect(viewModel.structures[1].spotsAvailable == 100)
        
        #expect(viewModel.structuresSupportedBySystem)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ParkingStructuresListContentView.ViewModel) {
        #expect(viewModel.structures.count == 2)
        
        #expect(viewModel.structures[0].id == "3")
        #expect(viewModel.structures[1].id == "4")
        
        #expect(viewModel.structures[0].capacity == 500)
        #expect(viewModel.structures[1].capacity == 350)
        
        #expect(viewModel.structures[0].name == "Knott Studios Lot")
        #expect(viewModel.structures[1].name == "Jim Miller Lot")
        
        #expect(viewModel.structures[0].spotsAvailable == 100)
        #expect(viewModel.structures[1].spotsAvailable == 12)
        
        #expect(viewModel.structuresSupportedBySystem)
    }
    
    func assertViewModelDataForEmptyMock(viewModel: ParkingStructuresListContentView.ViewModel) {
        #expect(viewModel.structures.isEmpty)
    }
    
    func assertViewModelDataForTertiaryMock(viewModel: ParkingStructuresListContentView.ViewModel) {
        #expect(viewModel.structuresSupportedBySystem == false)
    }
    
    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        await autoTest_startRefreshingDataRefreshesDataOnFirstCall()
    }
    
    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        await autoTest_startRefreshingDataRefreshesDataMultipleTimes()
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        await autoTest_stopRefreshingDataStopsDataUpdatesAfterCompletion()
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        await autoTest_refreshDataOnceUpdatesData()
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        await autoTest_refreshDataOnceDoesNothingIfNoData()
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        await autoTest_refreshDataOnceDoesNothingIfNoApolloClient()
    }
    
    @Test func refreshDataSetsUnsupportedStatusIfNoParkingSystem() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = tertiaryMock
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        let viewModel = ParkingStructuresListContentView.ViewModel(apolloNetworkModel: networkModel)
        
        let networkArguments = networkArguments
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        assertViewModelDataForTertiaryMock(viewModel: viewModel)
    }
}
