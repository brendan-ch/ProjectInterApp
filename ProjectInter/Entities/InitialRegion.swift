//
//  InitialRegion.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2026.03.24.
//

import MapKit

/// Represents the bounding region for a system's initial map view.
struct InitialRegion: Equatable {
    var topLeft: RawCoordinates
    var bottomRight: RawCoordinates

    var asMKCoordinateRegion: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(
            latitude: (topLeft.latitude + bottomRight.latitude) / 2,
            longitude: (topLeft.longitude + bottomRight.longitude) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: abs(topLeft.latitude - bottomRight.latitude),
            longitudeDelta: abs(topLeft.longitude - bottomRight.longitude)
        )
        return MKCoordinateRegion(center: center, span: span)
    }
}
