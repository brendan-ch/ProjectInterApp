//
//  StopInfoContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.20.
//

import SwiftUI

struct StopInfoContentView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Chapman Court")
                        .font(.title2)
                        .bold()
                        .accessibilityLabel("Shuttle name")
                }
                Spacer()
                Button("Close") {
                }
            }
            .padding()
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "return.right")
                    Text("Switch to this stop")
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
    StopInfoContentView()
}
