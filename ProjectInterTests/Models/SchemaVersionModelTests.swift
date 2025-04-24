//
//  SchemaVersionModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.24.
//

@testable import ProjectInter
import Testing
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

class SchemaVersionModelTests: NetworkDataModelTestsProtocol {
    let defaultMock = Mock<Query>(
        
    )
    
    let secondaryMock = Mock<Query>(
        
    )
    
    let networkArguments = SchemaVersionModelNetworkArguments()
    
    func assertViewModelDataForDefaultMock(viewModel: SchemaVersionModel) {
        
    }
    
    func assertViewModelDataForSecondaryMock(viewModel: SchemaVersionModel) {
        
    }
    
    func assertViewModelDataForEmptyMock(viewModel: SchemaVersionModel) {
        
    }
    
    func startRefreshingDataRefreshesDataOnFirstCall() async {
        await autoTest_startRefreshingDataRefreshesDataOnFirstCall()
    }
    
    func startRefreshingDataRefreshesDataMultipleTimes() async {
        await autoTest_startRefreshingDataRefreshesDataMultipleTimes()
    }
    
    func stopRefreshingDataStopsDataUpdatesAfterCompletion() async {
        await autoTest_stopRefreshingDataStopsDataUpdatesAfterCompletion()
    }
    
    func refreshDataOnceUpdatesData() async {
        await autoTest_refreshDataOnceUpdatesData()
    }
    
    func refreshDataOnceDoesNothingIfNoData() async {
        await autoTest_refreshDataOnceDoesNothingIfNoData()
    }
    
    func refreshDataOnceDoesNothingIfNoApolloClient() async {
        await autoTest_refreshDataOnceDoesNothingIfNoApolloClient()
    }
    
    
}
