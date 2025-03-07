//
//  GlobalLocationDataModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.21.
//

import Testing
@testable import ProjectInter

class GlobalLocationDataModelTests {
    @Test func requestAuthorizationSetsAuthorizationStatusAndLocation() async {
        let locationManager = MockCLLocationManager()
        locationManager.authorizationStatusToGrant = .authorizedWhenInUse
        let locationDataModel = GlobalLocationDataModel(locationManager: locationManager)
        
        locationDataModel.requestAuthorization()
        
        #expect(locationDataModel.authorizationStatus == .authorizedWhenInUse)
        #expect(locationDataModel.lastUpdatedLocation != nil)
    }
    
    @Test func creatingDataModelUpdatesLocationIfAuthorized() async {
        let locationManager = MockCLLocationManager()
        locationManager.authorizationStatusToGrant = .authorizedWhenInUse
        let locationDataModel = GlobalLocationDataModel(locationManager: locationManager)
        
        #expect(locationDataModel.lastUpdatedLocation != nil)
    }
    
    @Test func creatingDataModelDoesNotUpdateLocationIfNotAuthorized() async {
        let locationManager = MockCLLocationManager()
        locationManager.authorizationStatusToGrant = .denied
        let locationDataModel = GlobalLocationDataModel(locationManager: locationManager)
        
        #expect(locationDataModel.lastUpdatedLocation == nil)
    }
}
