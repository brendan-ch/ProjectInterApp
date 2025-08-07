//
//  ParkingStructureInfoContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.06.
//

import Foundation
import Testing
@testable import ProjectInter
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

class ParkingStructureInfoContentViewModelTestsMockData {
    static let defaultArguments = ParkingStructureNetworkingArguments(
        systemId: "1",
        parkingStructureId: "1"
    )
    
    static let calendar = Calendar.current
    
    static let defaultMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructure: .init(
                    capacity: 100,
                    historicalAverages: [
                        .init(
                            averageSpotsAvailable: 80,
                            from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date()),
                        ),
                        .init(
                            averageSpotsAvailable: 67,
                            from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()),
                        ),
                        .init(
                            averageSpotsAvailable: 55,
                            from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date()),
                        ),
                    ],
                    id: "1",
                    name: "Anderson Structure",
                    spotsAvailable: 50
                ),
            )
        )
    )
    
    static let secondaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructure: .init(
                    capacity: 150,
                    historicalAverages: [
                        .init(
                            averageSpotsAvailable: 140,
                            from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date()),
                        ),
                        .init(
                            averageSpotsAvailable: 110,
                            from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()),
                        ),
                        .init(
                            averageSpotsAvailable: 102,
                            from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date()),
                        ),
                    ],
                    id: "2",
                    name: "Barrera",
                    spotsAvailable: 100
                ),
            )
        )
    )
}

class ParkingStructureInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let defaultMock = ParkingStructureInfoContentViewModelTestsMockData.defaultMock
    let secondaryMock = ParkingStructureInfoContentViewModelTestsMockData.secondaryMock
    let networkArguments = ParkingStructureInfoContentViewModelTestsMockData.defaultArguments
    
    func assertViewModelDataForDefaultMock(viewModel: ParkingStructureInfoContentViewModel) {
        #expect(viewModel.capacity == 100)
        #expect(viewModel.spotsAvailable == 50)
        #expect(viewModel.name == "Anderson Structure")
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ParkingStructureInfoContentViewModel) {
        #expect(viewModel.capacity == 150)
        #expect(viewModel.spotsAvailable == 100)
        #expect(viewModel.name == "Barrera")
    }
    
    func assertViewModelDataForEmptyMock(viewModel: ProjectInter.ParkingStructureInfoContentViewModel) {
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
    
}
