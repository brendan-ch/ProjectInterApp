//
//  RootSheetContentView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI

struct RootSheetDefaultHeader: View {
    let title: String
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .bold()
            }
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
    }
}

struct RootSheetContentView<Header, Content>: View where Header: View, Content: View {
    let header: Header
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) where Header == RootSheetDefaultHeader {
        self.header = RootSheetDefaultHeader(title: title)
        self.content = content()
    }
    
    init(@ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content) {
        self.header = header()
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))

            ScrollView {
                content
            }
        }

    }
}

#Preview {
    VStack {
        RootSheetContentView(title: "Title") {
            Text("View content")
        }
        RootSheetContentView(header: {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Custom heading")
                        .font(.title2)
                        .bold()
                    Text("Subheading")
                }
                Spacer()
                Image(systemName: "xmark")
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
        }) {
            Text("View content with custom header")
        }
    }
}
