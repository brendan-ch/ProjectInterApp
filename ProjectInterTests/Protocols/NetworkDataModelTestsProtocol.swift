//
//  NetworkDataModelProtocolTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.14.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

protocol NetworkDataModelTestsProtocol {
    associatedtype DefaultMock
    associatedtype SecondaryMock
    associatedtype NetworkArguments
    associatedtype ViewModel: NetworkDataModelProtocol where ViewModel.T == NetworkArguments
    
    func assertViewModelDataForDefaultMock(viewModel: ViewModel)
    func assertViewModelDataForSecondaryMock(viewModel: ViewModel)
    
    var defaultMock: DefaultMock { get }
    var secondaryMock: SecondaryMock { get }
    
    var networkArguments: NetworkArguments { get }

    func startRefreshingDataRefreshesDataOnFirstCall() async
    func startRefreshingDataRefreshesDataMultipleTimes() async
    func stopRefreshingDataStopsDataUpdatesAfterCompletion() async
    func refreshDataOnceUpdatesData() async
    func refreshDataOnceDoesNothingIfNoData() async
    func refreshDataOnceDoesNothingIfNoApolloClient() async
}

extension NetworkDataModelTestsProtocol {
    func testStartRefreshingDataRefreshesDataOnFirstCall() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock as? Mock<Query>
        
        let viewModel = ViewModel(apolloClient: mockClient)
        viewModel.startRefreshingData(arguments: networkArguments, sleepDuration: .milliseconds(1000))
        try? await Task.sleep(for: .milliseconds(200))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
    }
    
    func testStartRefreshingDataRefreshesDataMultipleTimes() async {
        let mockClient = MockApolloClient()
        mockClient.queryMock = defaultMock as? Mock<Query>
        
        let viewModel = ViewModel(apolloClient: mockClient)
        let arguments = networkArguments
        
        viewModel.startRefreshingData(arguments: arguments, sleepDuration: .milliseconds(100))
        
        try? await Task.sleep(for: .milliseconds(500))
        
        assertViewModelDataForDefaultMock(viewModel: viewModel)
        
        mockClient.queryMock = secondaryMock as? Mock<Query>
        
        try? await Task.sleep(for: .milliseconds(600))
        
        assertViewModelDataForSecondaryMock(viewModel: viewModel)
    }
}
