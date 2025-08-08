//
//  RootSheetContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

struct RootSheetContentView<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
            
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))

            ScrollView {
                content
            }
        }

    }
}
