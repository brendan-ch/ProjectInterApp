//
//  RouteInfoContentView.swift
//  InterMVP0
//
//  Created by Brendan Chen on 2024.12.17.
//

import SwiftUI

struct RouteInfoContentView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        List {
//        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Red Route")
                        .font(.title2)
                        .bold()
                    Text("towards Chapman Grand")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Close") {
                    isShowing = false
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding()
        }
        .listStyle(.plain)
        .background(Color.clear)
    }
}

#Preview {
    RouteInfoContentView(isShowing: .constant(true))
}
