//
//  OpenParkingStructureArguments.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

/// Arguments needed for the app to open a parking structure, say,
/// from a URL or notification.
public struct OpenParkingStructureArguments: URLConstructable, URLRepresentable, Equatable {
    public let parkingStructureId: String
    public let systemId: String
    
    public init(parkingStructureId: String, systemId: String) {
        self.parkingStructureId = parkingStructureId
        self.systemId = systemId
    }
}

public extension OpenParkingStructureArguments {
    static var expectedUrlPath: String { "/openParkingStructure" }
}
