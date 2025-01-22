//
//  GlobalLocationDataModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.21.
//

import Testing
@testable import ProjectInter

class GlobalLocationDataModelTests {
    @Test func testRequestAuthorizationSetsAuthorizationStatus() async {
        let locationManager = MockCLLocationManager()
        locationManager.authorizationStatusToGrant = .authorizedWhenInUse
        let locationDataModel = GlobalLocationDataModel(locationManager: locationManager)
        
        locationDataModel.requestAuthorization()
        
        #expect(locationDataModel.authorizationStatus == .authorizedWhenInUse)
    }
    
    @Test func updateLocationOnceUpdatesLocationsIfAccessGranted() async {
        let locationManager = MockCLLocationManager()
        locationManager.authorizationStatusToGrant = .authorizedWhenInUse
        let locationDataModel = GlobalLocationDataModel(locationManager: locationManager)
        
        #expect(locationDataModel.lastUpdatedLocation == nil)

        locationDataModel.requestAuthorization()
        
        locationDataModel.updateLocationOnce()
        
        #expect(locationDataModel.lastUpdatedLocation != nil)
        #expect(locationDataModel.locationIsUpdating == false)
    }
    
    @Test func updateLocationOnceResetsLocationIsUpdatingIfDeniedError() async {
        let locationManager = MockCLLocationManager()
        locationManager.authorizationStatusToGrant = .denied
        let locationDataModel = GlobalLocationDataModel(locationManager: locationManager)
        
        locationDataModel.requestAuthorization()
        locationDataModel.updateLocationOnce()
        
        #expect(locationDataModel.locationIsUpdating == false)
    }
}
