//
//  ShuttleListContentView.swift
//  InterMVP1
//
//  Created by Brendan Chen on 2024.12.16.
//

import SwiftUI

struct ShuttleListContentView: View {
    @Binding var isPresented: Bool
    @Binding var isShowingNestedSheet: Bool
    
    var body: some View {
        List {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Shuttles")
                        .font(.title2)
                        .bold()
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding()

            Section(header: Text("Nearby")) {
                Button(action: {
                    isShowingNestedSheet = true
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Red Shuttle")
                                .bold()
                            Text("5 min. away")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical)
                        Spacer()
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal)

            Section(header: Text("Other")) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Teal Shuttle")
                            .bold()
                        Text("15 min. away")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal)
        }
        .listStyle(.plain)
        .background(Color.clear)
        .sheet(isPresented: $isShowingNestedSheet) {
            ShuttleInfoContentView(isShowing: $isShowingNestedSheet)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .presentationDetents([.height(210), .height(360), .large])
                .presentationBackground(.regularMaterial)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    ShuttleListContentView(isPresented: .constant(true), isShowingNestedSheet: .constant(false))
}
