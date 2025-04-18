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

class ParkingStructuresListParkingStructureTests {
    @Test func apolloDataInitializerInitializesData() {
        let data = GetParkingStructuresListDataQuery.Data.from(ParkingStructuresListContentViewModelTestsMockData.defaultMock)
        let parkingStructures = data.system!.parkingSystem!.parkingStructures!
        
        let constructedStructures = parkingStructures.map(ParkingStructuresListParkingStructure.init)
        
        for i in 0..<constructedStructures.count {
            #expect(constructedStructures[i].id == parkingStructures[i].id)
            #expect(constructedStructures[i].name == parkingStructures[i].name)
            #expect(constructedStructures[i].spotsAvailable == parkingStructures[i].spotsAvailable)
            #expect(constructedStructures[i].capacity == constructedStructures[i].capacity)
        }
    }
}

class ParkingStructuresListContentViewModelTests: NetworkDataModelTestsProtocol {
    let defaultArguments = ParkingStructuresListContentViewModelTestsMockData.defaultArguments
    let defaultMock = ParkingStructuresListContentViewModelTestsMockData.defaultMock
    let secondaryMock = ParkingStructuresListContentViewModelTestsMockData.secondaryMock
    
    func assertViewModelDataForDefaultMock(viewModel: ParkingStructuresListContentViewModel) {
        #expect(viewModel.structures.count == 2)
        
        #expect(viewModel.structures[0].id == "1")
        #expect(viewModel.structures[1].id == "2")
        
        #expect(viewModel.structures[0].capacity == 100)
        #expect(viewModel.structures[1].capacity == 200)
        
        #expect(viewModel.structures[0].name == "Anderson Structure")
        #expect(viewModel.structures[1].name == "Barrera")
        
        #expect(viewModel.structures[0].spotsAvailable == 50)
        #expect(viewModel.structures[1].spotsAvailable == 100)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ParkingStructuresListContentViewModel) {
        #expect(viewModel.structures.count == 2)
        
        #expect(viewModel.structures[0].id == "3")
        #expect(viewModel.structures[1].id == "4")
        
        #expect(viewModel.structures[0].capacity == 500)
        #expect(viewModel.structures[1].capacity == 350)
        
        #expect(viewModel.structures[0].name == "Knott Studios Lot")
        #expect(viewModel.structures[1].name == "Jim Miller Lot")
        
        #expect(viewModel.structures[0].spotsAvailable == 100)
        #expect(viewModel.structures[1].spotsAvailable == 12)
    }
    
    @Test func startRefreshingDataRefreshesDataOnFirstCall() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock
        
        let viewModel = ParkingStructuresListContentViewModel(apolloClient: mockClient)
        
        let networkArguments = defaultArguments
        viewModel.startRefreshingData(arguments: networkArguments)
        
        try? await Task.sleep(for: .milliseconds(500))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func startRefreshingDataRefreshesDataMultipleTimes() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock
        
        let viewModel = ParkingStructuresListContentViewModel(apolloClient: mockClient)
        
        let networkArguments = defaultArguments
        viewModel.startRefreshingData(arguments: networkArguments, sleepDuration: .milliseconds(100))
        
        try? await Task.sleep(for: .milliseconds(500))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
        
        let updatedMock = secondaryMock
        mockClient.queryMock = updatedMock
        
        try? await Task.sleep(for: .milliseconds(500))
        
        assertViewModelDataForSecondaryMock(viewModel: viewModel)
    }
    
    @Test func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock
        
        let viewModel = ParkingStructuresListContentViewModel(apolloClient: mockClient)
        
        let networkArguments = defaultArguments
        viewModel.startRefreshingData(arguments: networkArguments, sleepDuration: .milliseconds(100))
        
        try? await Task.sleep(for: .milliseconds(500))
        
        viewModel.stopRefreshingData()
        mockClient.queryMock = secondaryMock
        
        try? await Task.sleep(for: .milliseconds(700))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceUpdatesData() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock
        
        let viewModel = ParkingStructuresListContentViewModel(apolloClient: mockClient)
        
        let networkArguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = nil
        
        let viewModel = ParkingStructuresListContentViewModel(apolloClient: mockClient)
        
        let networkArguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.structures.isEmpty)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoApolloClient() async {
        let viewModel = ParkingStructuresListContentViewModel()
        
        let networkArguments = defaultArguments
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.structures.isEmpty)
    }
}
