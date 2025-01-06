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
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
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
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func updateLocationOnce() {
        locationManager?.requestLocation()
    }
}
