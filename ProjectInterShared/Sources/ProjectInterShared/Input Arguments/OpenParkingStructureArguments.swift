//
//  OpenParkingStructureArguments.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.02.
//

/// Arguments needed for the app to open a parking structure, say,
/// from a URL or notification.
public struct OpenParkingStructureArguments: URLConstructable, Equatable {
    public let parkingStructureId: String
    public let systemId: String
}

public extension OpenParkingStructureArguments {
    static var expectedUrlPath: String { "/openParkingStructure" }
}
