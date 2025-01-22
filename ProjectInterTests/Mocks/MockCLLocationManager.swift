//
//  MockGlobalLocationModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.21.
//

import CoreLocation

class MockCLLocationManager: CLLocationManager {
    var mockLocationAccessGranted = false
    
    override func requestAlwaysAuthorization() {
        mockLocationAccessGranted = true
        delegate?.locationManager?(self, didChangeAuthorization: CLAuthorizationStatus.authorizedAlways)
    }
    
    override func requestLocation() {
        let locations: [CLLocation] = [
            CLLocation(latitude: 10, longitude: 10),
            CLLocation(latitude: 20, longitude: 20)
        ]
        
        delegate?.locationManager?(self, didUpdateLocations: locations)
    }
}
