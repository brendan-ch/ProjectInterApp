//
//  GlobalLocationDataModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.21.
//

import Testing
@testable import ProjectInter

class GlobalLocationDataModelTests {
    @Test func testRequestAuthorizationSetsAuthorizationStatus() {
        let locationManager = MockCLLocationManager()
        locationManager.authorizationStatusToGrant = .authorizedWhenInUse
        let locationDataModel = GlobalLocationDataModel(locationManager: locationManager)
        
        locationDataModel.requestAuthorization()
        
        #expect(locationManager.authorizationStatus == .authorizedWhenInUse)
    }
}
