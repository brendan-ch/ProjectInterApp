//
//  SystemSelectionSetupView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.30.
//

import SwiftUI

struct SystemSelectionSetupView: View {
    @EnvironmentObject var systemsModel: GlobalSystemsModel
    
    var onContinue: () -> Void
    
    @State private var showSystemSelectionView = false

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 56)
            
            Text("Pick a system")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("This is the system of routes, shuttles, and parking data you want to view.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            if let system = systemsModel.selectedSystem {
                Text("Currently selected: \(system.name)")
            } else {
                Text("No system selected.")
            }
            
            Button {
                showSystemSelectionView = true
            } label: {
                Spacer()
                
                if let system = systemsModel.selectedSystem {
                    Text("Change system")
                        .bold()
                } else {
                    Text("Select system")
                        .bold()
                }
                
                Spacer()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            Button {
                Task {
                    
                    onContinue()
                }
            } label: {
                Spacer()
                
                Text("Continue")
                    .bold()
                
                Spacer()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(systemsModel.selectedSystem == nil)
        }
        .padding()
        .sheet(isPresented: $showSystemSelectionView) {
            SystemSelectionView()
        }
    }
}

#Preview {
    SystemSelectionSetupView {
        print("Continue pressed")
    }
        .environmentObject(GlobalSystemsModel())
}
