//
//  StopAnnotationView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.20.
//

import SwiftUI

struct StopAnnotationView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.white)
            RoundedRectangle(cornerRadius: 100)
                .stroke(.black, lineWidth: 2)
        }
        .accessibilityLabel("Stop")
        .accessibilityAddTraits(.isButton)
    }
}
