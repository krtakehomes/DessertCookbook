//
//  CardView.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

/// A styled container view that wraps the provided content
/// 
/// - Parameters:
///   - backgroundColor: The background color of the card
///   - cornerRadius: The corner radius of the card
///   - hasShadow: A boolean that determines if the card has a shadow
///   - content: The content to be displayed within the card
struct CardView<Content: View>: View {
    @ViewBuilder private let content: Content
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let hasShadow: Bool
    
    init(backgroundColor: Color = .white, cornerRadius: CGFloat = 8, hasShadow: Bool = true, content: @escaping () -> Content) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.hasShadow = hasShadow
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Group {
                if hasShadow {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(backgroundColor)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .shadow(color: backgroundColor.opacity(0.3), radius: 20, x: 0, y: 10)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(backgroundColor)
                }
            }
            
            content
        }
    }
}

#Preview {
    CardView {
        Text("Hello, world!")
            .padding()
    }
}
