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


class ParkingStructureInfoContentViewModelTests: NetworkDataModelTestsProtocol {
    let calendar = Calendar.current
    let defaultMock = MockData.defaultMock
    let secondaryMock = MockData.secondaryMock
    let tertiaryMock = MockData.tertiaryMock
    let networkArguments = MockData.defaultArguments
    
    func assertViewModelDataForDefaultMock(viewModel: ParkingStructureInfoContentView.ViewModel) {
        #expect(viewModel.capacity == 100)
        #expect(viewModel.spotsAvailable == 50)
        #expect(viewModel.name == "Anderson Structure")
        #expect(viewModel.address == "300 E Walnut Ave, Orange, CA 92867 United States")

        #expect(viewModel.averages?.count == 3)
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: ParkingStructureInfoContentView.ViewModel) {
        #expect(viewModel.capacity == 150)
        #expect(viewModel.spotsAvailable == 100)
        #expect(viewModel.name == "Barrera")
        #expect(viewModel.address == "200 W Sycamore Ave, Orange, CA 92866 United States")
        
        #expect(viewModel.averages?.count == 4)
    }
    
    func assertViewModelDataForEmptyMock(viewModel: ProjectInter.ParkingStructureInfoContentView.ViewModel) {
        #expect(viewModel.capacity == nil)
        #expect(viewModel.spotsAvailable == nil)
        #expect(viewModel.name == nil)
        
        #expect(viewModel.averages == nil)
        #expect(viewModel.startOfCurrentTimePeriod == nil)
        #expect(viewModel.endOfCurrentTimePeriod == nil)
    }
    
    func constructViewModelWithAverages() -> ParkingStructureInfoContentView.ViewModel {
        let now = Date()
        let viewModel = ParkingStructureInfoContentView.ViewModel()
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
    
    func constructViewModelWithReferenceDate(_ date: Date) -> (MockApolloClient, ViewModel) {
        let mockClient = MockApolloClient()
        let mockNetworkModel = ApolloNetworkModel(client: mockClient)
        let viewModel = ParkingStructureInfoContentView.ViewModel(apolloNetworkModel: mockNetworkModel, referenceDate: date)
        
        return (mockClient, viewModel)
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
        let expectedFrom = calendar.date(bySettingHour: ParkingStructureInfoContentView.ViewModel.startingHour, minute: 0, second: 0, of: oneWeekAgo)!
        let expectedTo = calendar.date(bySettingHour: ParkingStructureInfoContentView.ViewModel.endingHour, minute: 0, second: 0, of: oneWeekAgo)!
        
        let viewModel = ParkingStructureInfoContentView.ViewModel()
        let input = viewModel.generateHistoricalAverageInput(for: oneWeekAgo)
        
        #expect(input?.from == expectedFrom)
        #expect(input?.to == expectedTo)
        #expect(input?.intervalMs == ParkingStructureInfoContentView.ViewModel.intervalMs)
    }
    
    @Test func viewModelCorrectlyGeneratesParkingInsightIfLessSpotsAvailable() async {
        let (mockClient, viewModel) = constructViewModelWithReferenceDate(calendar.date(bySettingHour: 8, minute: 5, second: 0, of: Date())!)
        mockClient.queryMock = defaultMock
        
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.parkingInsight?.contains("Anderson Structure") == true)
        #expect(viewModel.parkingInsight?.contains("150%") == true)
        #expect(viewModel.parkingInsight?.contains("more") == true)
    }
    
    @Test func viewModelCorrectlyGeneratesParkingInsightIfMoreSpotsAvailable() async {
        let (mockClient, viewModel) = constructViewModelWithReferenceDate(calendar.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!)
        mockClient.queryMock = secondaryMock
        
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.parkingInsight?.contains("Barrera") == true)
        #expect(viewModel.parkingInsight?.contains("9%") == true)
        #expect(viewModel.parkingInsight?.contains("less") == true)
    }
    
    @Test func viewModelCorrectlyGeneratesParkingInsightIfSameNumberOfSpotsAvailable() async {
        let (mockClient, viewModel) = constructViewModelWithReferenceDate(calendar.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!)
        mockClient.queryMock = secondaryMock
        
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.parkingInsight == "Barrera was also around this filled last week.")
    }
    
    @Test func viewModelCorrectlyGeneratesParkingInsightIfParkingLotEmpty() async {
        let (mockClient, viewModel) = constructViewModelWithReferenceDate(calendar.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!)
        mockClient.queryMock = tertiaryMock
        
        await viewModel.refreshDataOnce(arguments: networkArguments)
        
        #expect(viewModel.parkingInsight == nil)
    }
    
    @Test func viewModelCorrectlyLoadsCurrentDayHistoricalData() async {
        let (mockClient, viewModel) = constructViewModelWithReferenceDate(calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!)
        
        // Use the current date for the mock
        mockClient.queryMock = .init(
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
        
        await viewModel.loadCurrentDayHistorical(networkArguments)
        
        #expect(viewModel.currentDayAverages?.count == 3)
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
    
    class MockData {
        static let defaultArguments = ParkingStructureNetworkingArguments(
            systemId: "1",
            parkingStructureId: "1"
        )
        
        static let calendar = Calendar.current
        static var oneWeekAgo: Date! {
            MockData.calendar.date(byAdding: .day, value: -7, to: Date())!
        }
        
        static let defaultMock = Mock<ProjectInterTestMocks.Query>(
            system: .init(
                parkingSystem: .init(
                    parkingStructure: .init(
                        address: "300 E Walnut Ave, Orange, CA 92867 United States",
                        capacity: 100,
                        historicalAverages: [
                            .init(
                                averageSpotsAvailable: 80,
                                from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: MockData.oneWeekAgo),
                                to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo)
                            ),
                            .init(
                                averageSpotsAvailable: 67,
                                from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo),
                                to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo)
                            ),
                            .init(
                                averageSpotsAvailable: 55,
                                from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo),
                                to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: MockData.oneWeekAgo)
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
                                from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: MockData.oneWeekAgo),
                                to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo)
                            ),
                            .init(
                                averageSpotsAvailable: 110,
                                from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo),
                                to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo)
                            ),
                            .init(
                                averageSpotsAvailable: 100,
                                from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo),
                                to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: MockData.oneWeekAgo)
                            ),
                            .init(
                                averageSpotsAvailable: 95,
                                from: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: MockData.oneWeekAgo),
                                to: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: MockData.oneWeekAgo)
                            )
                        ],
                        id: "2",
                        name: "Barrera",
                        spotsAvailable: 100
                    )
                )
            )
        )
        
        static let tertiaryMock = Mock<ProjectInterTestMocks.Query>(
            system: .init(
                parkingSystem: .init(
                    parkingStructure: .init(
                        address: "200 W Sycamore Ave, Orange, CA 92866 United States",
                        capacity: 100,
                        id: "2",
                        name: "Barrera",
                        spotsAvailable: 100
                    )
                )
            )

        )
    }
}
