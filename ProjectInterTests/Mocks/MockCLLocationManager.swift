//
//  MockGlobalLocationModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.21.
//

import CoreLocation

class MockCLLocationManager: CLLocationManager {
    var authorizationStatusToGrant = CLAuthorizationStatus.authorizedAlways
    
    override func requestAlwaysAuthorization() {
        delegate?.locationManager?(self, didChangeAuthorization: authorizationStatusToGrant)
    }
    
    override func requestLocation() {
        let locations: [CLLocation] = [
            CLLocation(latitude: 10, longitude: 10),
            CLLocation(latitude: 20, longitude: 20)
        ]
        
        delegate?.locationManager?(self, didUpdateLocations: locations)
    }
}
