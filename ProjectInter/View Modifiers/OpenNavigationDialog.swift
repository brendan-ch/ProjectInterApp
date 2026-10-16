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
                    openUrl(address?.toAppleMapsUrl())
                } label: {
                    Text("Apple Maps")
                }
                
                Button {
                    openUrl(address?.toGoogleMapsUrl())
                } label: {
                    Text("Google Maps")
                }
            }
    }
    
    func openUrl(_ url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
}
