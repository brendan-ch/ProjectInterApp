//
//  MapView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = MapViewModel()
    
    var body: some View {
        Map(position: $viewModel.position) {
            UserAnnotation()
            
            ForEach(viewModel.shuttles) { shuttle in
                Annotation(
                    shuttle.name,
                    coordinate: shuttle.coordinates,
                    anchor: .center
                ) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color(hex: shuttle.routeColorHex))
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(.white, lineWidth: 4)
                        Image(systemName: "bus.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(6)
                            .foregroundStyle(Color.white)
                    }
                }
                .annotationTitles(.visible)
                .tag(shuttle.id)
            }
        }
        .onAppear {
            viewModel.addPlaceholderData()
        }
    }
}

#Preview {
    MapView()
}
