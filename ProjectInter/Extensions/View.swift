//
//  View.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.06.22.
//

import SwiftUI

struct ConditionalForegroundStyle: ViewModifier {
    let style: Color?
    
    func body(content: Content) -> some View {
        if let style = style {
            content.foregroundStyle(style)
        } else {
            content
        }
    }
}

extension View {
    func conditionalForegroundStyle(_ style: Color?) -> some View {
        modifier(ConditionalForegroundStyle(style: style))
    }
    
    func openNavigationDialog(_ address: String?, isPresented: Binding<Bool>) -> some View {
        modifier(OpenNavigationDialog(isPresented: isPresented, address: address))
    }
    
    @ViewBuilder
    func prominentButtonStyleByAvailability() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    func secondaryButtonStyleByAvailability() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    func apply<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
