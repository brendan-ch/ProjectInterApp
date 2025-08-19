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
                    address: "300 E Walnut Ave, Orange, CA 92867 United States",
                    capacity: 100,
                    historicalAverages: [
                        .init(
                            averageSpotsAvailable: 80,
                            from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date())
                        ),
                        .init(
                            averageSpotsAvailable: 67,
                            from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
                        ),
                        .init(
                            averageSpotsAvailable: 55,
                            from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date())
                        )
                    ],
                    id: "1",
                    name: "Anderson Structure",
                    spotsAvailable: 50
                )
            )
        )
    )
    
    static let secondaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructure: .init(
                    address: "200 W Sycamore Ave, Orange, CA 92866 United States",
                    capacity: 150,
                    historicalAverages: [
                        .init(
                            averageSpotsAvailable: 140,
                            from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date())
                        ),
                        .init(
                            averageSpotsAvailable: 110,
                            from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
                        ),
                        .init(
                            averageSpotsAvailable: 102,
                            from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date())
                        ),
                        .init(
                            averageSpotsAvailable: 95,
                            from: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date()),
                            to: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: Date())
                        )
                    ],
                    id: "2",
                    name: "Barrera",
                    spotsAvailable: 100
                )
            )
        )
    )
}

class ParkingStructureInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let calendar = Calendar.current
    let defaultMock = ParkingStructureInfoContentViewModelTestsMockData.defaultMock
    let secondaryMock = ParkingStructureInfoContentViewModelTestsMockData.secondaryMock
    let networkArguments = ParkingStructureInfoContentViewModelTestsMockData.defaultArguments
    
    func assertViewModelDataForDefaultMock(viewModel: ParkingStructureInfoContentViewModel) {
        #expect(viewModel.capacity == 100)
        #expect(viewModel.spotsAvailable == 50)
        #expect(viewModel.name == "Anderson Structure")
        #expect(viewModel.address == "300 E Walnut Ave, Orange, CA 92867 United States")

        #expect(viewModel.averages?.count == 3)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ParkingStructureInfoContentViewModel) {
        #expect(viewModel.capacity == 150)
        #expect(viewModel.spotsAvailable == 100)
        #expect(viewModel.name == "Barrera")
        #expect(viewModel.address == "200 W Sycamore Ave, Orange, CA 92866 United States")
        
        #expect(viewModel.averages?.count == 4)
    }
    
    func assertViewModelDataForEmptyMock(viewModel: ProjectInter.ParkingStructureInfoContentViewModel) {
        #expect(viewModel.capacity == nil)
        #expect(viewModel.spotsAvailable == nil)
        #expect(viewModel.name == nil)
        
        #expect(viewModel.averages == nil)
        #expect(viewModel.startOfCurrentTimePeriod == nil)
        #expect(viewModel.endOfCurrentTimePeriod == nil)
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
            )
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
    
    @Test func getAppleMapsUrlGetsTheCorrectUrl() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.queryMock = defaultMock
        await viewModel.refreshDataOnce(arguments: arguments)
        
        let url = viewModel.getAppleMapsUrlForParkingStructure()
        let expectedAddress = defaultMock.system?.parkingSystem?.parkingStructure?.address
        let percentageEncodedExpectedAddress = expectedAddress?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        #expect(url?.absoluteString == "https://maps.apple.com/?address=\(percentageEncodedExpectedAddress!)")
    }
    
    @Test func getGoogleMapsUrlGetsTheCorrectUrl() async {
        let (mockClient, viewModel, arguments) = generateClientAndViewModelWithArguments()
        mockClient.queryMock = defaultMock
        await viewModel.refreshDataOnce(arguments: arguments)
        
        let url = viewModel.getGoogleMapsUrlForParkingStructure()
        let expectedAddress = defaultMock.system?.parkingSystem?.parkingStructure?.address
        let percentageEncodedExpectedAddress = expectedAddress?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        #expect(url?.absoluteString == "https://www.google.com/maps?q=\(percentageEncodedExpectedAddress!)")
    }
}
