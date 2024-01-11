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
                CachedAsyncImage(url: URL(string: dessert.imageURLString)!) { phase in
                    switch phase {
                        case .empty:
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(width: imageSize)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: imageSize)
                        case .failure:
                            Image(systemName: defaultImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: imageSize)
                        @unknown default:
                            Image(systemName: defaultImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: imageSize)
                    }
                }
                .frame(height: imageSize)
                Text(dessert.name)
                    .font(.callout)
                Spacer()
                Image(systemName: navigationIndicatorImageName)
            }
            .padding()
        }
    }
}
    
