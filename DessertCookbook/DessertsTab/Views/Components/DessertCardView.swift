//
//  DessertCardView.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

/// A view that displays basic information about a dessert, such as its image and name
struct DessertCardView: View {
    let dessert: Dessert
    private let imageSize: CGFloat = 75
    private let defaultImageName = "photo"
    private let navigationIndicatorImageName = "chevron.right"
    
    var body: some View {
        CardView {
            HStack(spacing: 16) {
                CachedAsyncImage(url: URL(string: dessert.imageURLString)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } loadingContent: {
                    ProgressView()
                        .progressViewStyle(.circular)
                } errorContent: {
                    Image(systemName: defaultImageName)
                }
                .frame(width: imageSize, height: imageSize)
                
                Text(dessert.name)
                    .font(.callout)
                Spacer()
                Image(systemName: navigationIndicatorImageName)
            }
            .padding()
        }
    }
}
    
