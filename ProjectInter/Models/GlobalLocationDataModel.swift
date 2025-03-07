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
    
    /// Updated once when the app is first started.
    @Published var authorizationStatusInitialized: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var lastUpdatedLocation: CLLocationCoordinate2D?
    
    @Published private(set) var locationIsUpdating: Bool = false
    
    convenience override init() {
        self.init(locationManager: CLLocationManager())
    }
    
    init(locationManager: CLLocationManager) {
        super.init()
        self.locationManager = locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        
        startUpdatingLocation()
    }
    
    func requestAuthorization() {
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Also runs when the manager is first created
        authorizationStatusInitialized = true
        authorizationStatus = status
        startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        lastUpdatedLocation = CLLocationCoordinate2D(
            latitude: mostRecentLocation.coordinate.latitude,
            longitude: mostRecentLocation.coordinate.longitude
        )
        
#if DEBUG
        print("Location updated: \(mostRecentLocation)")
#endif
        
        locationIsUpdating = false
    }
    
    private func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
        locationIsUpdating = false
    }
}
