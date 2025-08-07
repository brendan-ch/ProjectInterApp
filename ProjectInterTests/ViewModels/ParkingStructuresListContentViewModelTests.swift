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
    let calendar = Calendar.current
    let networkArguments = ParkingStructuresListContentViewModelTestsMockData.defaultArguments
    let defaultMock = ParkingStructuresListContentViewModelTestsMockData.defaultMock
    let secondaryMock = ParkingStructuresListContentViewModelTestsMockData.secondaryMock
    let tertiaryMock = ParkingStructuresListContentViewModelTestsMockData.tertiaryMock
    
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
        
        #expect(viewModel.structuresSupportedBySystem)
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
        
        #expect(viewModel.structuresSupportedBySystem)
    }
    
    func assertViewModelDataForEmptyMock(viewModel: ParkingStructuresListContentViewModel) {
        #expect(viewModel.structures.isEmpty)
    }
    
    func assertViewModelDataForTertiaryMock(viewModel: ParkingStructuresListContentViewModel) {
        #expect(viewModel.structuresSupportedBySystem == false)
    }
    
    func constructViewModelWithAverages() -> ParkingStructureInfoContentViewModel {
        let now = Date()
        let viewModel = ParkingStructureInfoContentViewModel()
        viewModel.averages = [
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
        ]
        
        return viewModel
    }
    
    @Test func findAverageCorrespondingToDateReturnsCorrectAverage() {
        let now = Date()
        let viewModel = constructViewModelWithAverages()
        
        let dateInput = calendar.date(bySettingHour: 13, minute: 0, second: 0, of: now)!
        let result = viewModel.findAverageCorrespondingToDate(dateInput)
        
        #expect(result?.from == viewModel.averages![2].from)
        #expect(result?.to == viewModel.averages![2].to)
    }
    
    @Test func findAverageCorrespondingToDateReturnsNil() {
        let now = Date()
        let viewModel = constructViewModelWithAverages()

        let dateInput = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!
        let result = viewModel.findAverageCorrespondingToDate(dateInput)
        
        #expect(result == nil)
    }

    
    @Test func viewModelCorrectlyGeneratesHistoricalAverageInput() {
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        let expectedFrom = calendar.date(bySettingHour: ParkingStructureInfoContentViewModel.startingHour, minute: 0, second: 0, of: oneWeekAgo)!
        let expectedTo = calendar.date(bySettingHour: ParkingStructureInfoContentViewModel.endingHour, minute: 0, second: 0, of: oneWeekAgo)!
        
        let viewModel = ParkingStructureInfoContentViewModel()
        let input = viewModel.generateHistoricalAverageInput()
        
        
        #expect(input.from == expectedFrom)
        #expect(input.to == expectedTo)
        #expect(input.intervalMs == ParkingStructureInfoContentViewModel.intervalMs)
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
        
        let viewModel = ParkingStructuresListContentViewModel(apolloClient: mockClient)
        
        let networkArguments = networkArguments
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        assertViewModelDataForTertiaryMock(viewModel: viewModel)
    }
}
