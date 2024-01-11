//
//  ExpandableCardView.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/9/24.
//

import SwiftUI

/// A view that displays an expandable ``CardView`` with a fixed label view and a content view visible only in the expanded state
///
/// - Parameters:
///   - isExpanded: Determines if the card view is expanded to reveal its content
///   - showsIndicator: Determines if the card view should display a chevron to indicate its expandable capability
///   - label: A view that will be fixed to the top of the card view and maintain constant visibility
///   - content: A view that will be displayed beneath the label and within the card view when it is expanded
struct ExpandableCardView<Label: View, Content: View>: View {
    @Binding private var isExpanded: Bool
    @ViewBuilder private let label: Label
    @ViewBuilder private let content: Content
    private let showsIndicator: Bool
    private let indicatorImageName = "chevron.down"
    
    init(isExpanded: Binding<Bool>,
         showsIndicator: Bool = true,
         label: @escaping () -> Label,
         content: @escaping () -> Content) {
        self._isExpanded = isExpanded
        self.showsIndicator = showsIndicator
        self.label = label()
        self.content = content()
    }
    
    private var indicatorDegrees: CGFloat {
        isExpanded ? -180 : 0
    }
    
    private var contentHeight: CGFloat? {
        isExpanded ? nil : 0
    }
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 0) {
                Button(action: didTapLabel) {
                    HStack(spacing: 0) {
                        label
                        
                        if showsIndicator {
                            Spacer()
                            Image(systemName: indicatorImageName)
                                .rotationEffect(Angle(degrees: indicatorDegrees))
                                .animation(.smooth, value: isExpanded)
                        }
                    }
                    .padding()
                }
                
                content
                    .padding([.horizontal, .bottom])
                    .frame(height: contentHeight, alignment: .bottom)
                    .clipped()
            }
        }
    }
    
    /// Handles the user's tap on the label by toggling the card view's expanded state
    private func didTapLabel() {
        withAnimation(.smooth) {
            isExpanded.toggle()
        }
    }
}

#Preview {
    ExpandableCardView(isExpanded: .constant(true)) {
        Text("Label")
    } content: {
        Text("Content")
    }
}
