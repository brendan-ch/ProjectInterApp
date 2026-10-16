//
//  StringTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2026.10.16.
//

import Testing
import Foundation
@testable import ProjectInter

class StringTests {
    private let mockAddress = "300 E Walnut Ave, Orange, CA 92867 United States"
    
    // MARK: - toAppleMapsUrl() tests
    
    /// See Apple's [Adopting unified Maps URLs](https://developer.apple.com/documentation/mapkit/unified-map-urls)
    /// for the `place?address=` URL format.
    @Test func testToAppleMapsUrlMatchesDocumentedFormat() throws {
        let url = try #require(mockAddress.toAppleMapsUrl())
        
        #expect(url.scheme == "https")
        #expect(url.host == "maps.apple.com")
        #expect(url.path == "/place")
        #expect(url.query == "address=300%20E%20Walnut%20Ave,%20Orange,%20CA%2092867%20United%20States")
    }
    
    /// Addresses containing characters which break query parameter
    /// construction (`&`, `=`, `+`) must percent-encode and decode back intact.
    @Test(arguments: [
        "300 E Walnut Ave, Orange, CA 92867 United States",
        "Park & Main Ave, Los Angeles, CA 90012",
        "A+B=1, City, CA 90000",
        "",
    ])
    func testToAppleMapsUrlRoundTripsAddress(address: String) throws {
        let url = try #require(address.toAppleMapsUrl())
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItem = try #require(components.queryItems?.first { $0.name == "address" })
        
        #expect(queryItem.value == address)
    }
    
    @Test func testToAppleMapsUrlForEmptyAddress() throws {
        let url = try #require("".toAppleMapsUrl())
        
        #expect(url.query == "address=")
    }
    
    // MARK: - toGoogleMapsUrl() tests
    
    /// See Google's [Maps URLs](https://developers.google.com/maps/documentation/urls/get-started)
    /// for the `search/?api=1&query=` URL format. `api=1` is required.
    @Test func testToGoogleMapsUrlMatchesDocumentedFormat() throws {
        let url = try #require(mockAddress.toGoogleMapsUrl())
        
        #expect(url.scheme == "https")
        #expect(url.host == "www.google.com")
        #expect(url.absoluteString.hasPrefix("https://www.google.com/maps/search/?api=1&query="))
        #expect(url.query == "api=1&query=300%20E%20Walnut%20Ave,%20Orange,%20CA%2092867%20United%20States")
    }
    
    /// Addresses containing characters which break query parameter
    /// construction (`&`, `=`, `+`) must percent-encode and decode back intact.
    @Test(arguments: [
        "300 E Walnut Ave, Orange, CA 92867 United States",
        "Park & Main Ave, Los Angeles, CA 90012",
        "A+B=1, City, CA 90000",
        "",
    ])
    func testToGoogleMapsUrlRoundTripsAddress(address: String) throws {
        let url = try #require(address.toGoogleMapsUrl())
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItem = try #require(components.queryItems?.first { $0.name == "query" })
        
        #expect(queryItem.value == address)
    }
    
    @Test func testToGoogleMapsUrlForEmptyAddress() throws {
        let url = try #require("".toGoogleMapsUrl())
        
        #expect(url.query == "api=1&query=")
    }
}
