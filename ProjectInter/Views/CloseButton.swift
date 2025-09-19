//
//  CloseButton.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.19.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        if #available(iOS 26.0, *) {
            Button {
                action()
            } label: {
                Image(systemName: "multiply")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .accessibilityLabel("Close")
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .tint(.secondary)
        } else {
            Button {
                action()
            } label: {
                Image(systemName: "multiply")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .accessibilityLabel("Close")
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
            .tint(.secondary)
        }

    }
}

#Preview {
    CloseButton {
        print("Close button pressed")
    }
}
