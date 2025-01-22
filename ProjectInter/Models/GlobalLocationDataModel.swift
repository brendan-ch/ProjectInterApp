//
//  LocationManagerState.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.27.
//

import SwiftUI
import CoreLocation

/// Global data model which manages location permissions.
class GlobalLocationDataModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var lastUpdatedLocation: CLLocationCoordinate2D?
    
    @Published private(set) var locationIsUpdating: Bool = false
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.delegate = self
    }
    
    convenience init(locationManager: CLLocationManager) {
        self.init()
        self.locationManager = locationManager
    }
    
    func requestAuthorization() {
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        lastUpdatedLocation = CLLocationCoordinate2D(
            latitude: mostRecentLocation.coordinate.latitude,
            longitude: mostRecentLocation.coordinate.longitude
        )
        locationIsUpdating = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func updateLocationOnce() {
        if locationIsUpdating {
            return
        }
        
        locationIsUpdating = true
        locationManager?.requestLocation()
    }
}
