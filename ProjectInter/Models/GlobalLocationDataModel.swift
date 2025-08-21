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
    @Published private(set) var authorizationStatusInitialized: Bool = false
    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var lastUpdatedLocation: CLLocationCoordinate2D?
    
    var isAuthorized: Bool {
        authorizationStatus == .authorizedAlways
        || authorizationStatus == .authorizedWhenInUse
    }
    
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
        Loggers.shared.systemEventsLogger.notice("Requesting location authorization")
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Loggers.shared.systemEventsLogger.notice("Location authorization status changed to \(status.rawValue)")
        // Also runs when the manager is first created
        authorizationStatusInitialized = true
        authorizationStatus = status
        startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            Loggers.shared.systemEventsLogger.warning("Location update received but data is empty, skipping update")
            return
        }
        Loggers.shared.systemEventsLogger.notice("Received a location update")
        Loggers.shared.systemEventsLogger.debug("\(mostRecentLocation)")
        
        lastUpdatedLocation = CLLocationCoordinate2D(
            latitude: mostRecentLocation.coordinate.latitude,
            longitude: mostRecentLocation.coordinate.longitude
        )
        
        locationIsUpdating = false
    }
    
    private func startUpdatingLocation() {
        Loggers.shared.systemEventsLogger.notice("Starting location updates")
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        Loggers.shared.systemEventsLogger.warning("Location update failed with error: \(error)")
        locationIsUpdating = false
    }
}
