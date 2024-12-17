//
//  ShuttleInfoContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

struct ShuttleInfoContentView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Red Shuttle")
                        .font(.title2)
                        .bold()
                    Text("Jacaranda St.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("5 min away")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("Last updated now")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Close") {
                    isShowing = false
                }
            }
            .padding()
            
            Button(action: {}) {
                HStack {
                    Spacer()
                    Image(systemName: "bell.badge")
                    Text("Notify me when nearby")
                    Spacer()
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
        }
    }
}

#Preview {
    ShuttleInfoContentView(isShowing: .constant(true))
}
