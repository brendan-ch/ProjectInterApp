//
//  OpenNavigationDialog.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.19.
//

import SwiftUI

struct OpenNavigationDialog: ViewModifier {
    let isPresented: Binding<Bool>
    let address: String?
    private var percentageEncodedAddress: String? {
        address?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog("Select an app", isPresented: isPresented, titleVisibility: .visible) {
                Button {
                    let url = getAppleMapsUrl()
                    openUrl(url)
                } label: {
                    Text("Apple Maps")
                }
                
                Button {
                    let url = getGoogleMapsUrl()
                    openUrl(url)
                } label: {
                    Text("Google Maps")
                }
            }
    }
    
    func openUrl(_ url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
    
    /// Get the Apple Maps URL of the parking structure, if exists.
    /// See [how to generate Maps links](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html).
    func getAppleMapsUrl() -> URL? {
        guard let percentageEncodedAddress = percentageEncodedAddress else { return nil }
        return URL(string: "https://maps.apple.com/?address=\(percentageEncodedAddress)")
    }
    
    func getGoogleMapsUrl() -> URL? {
        guard let percentageEncodedAddress = percentageEncodedAddress else { return nil }
        return URL(string: "https://www.google.com/maps?q=\(percentageEncodedAddress)")
    }

}
