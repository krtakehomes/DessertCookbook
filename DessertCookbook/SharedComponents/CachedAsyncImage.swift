//
//  CachedAsyncImage.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

/// A view that combines asynchronous image loading provided by `AsyncImage`, with in-memory caching via ``ImageCache``
///
/// Use `CachedAsyncImage` to request and load images asynchronously from the provided URL and cache them into memory for more performant
/// subsequent retrievals. The cached images are stored using ``ImageCache``.
///
/// - Note: The actual rendering of the image is determined by the provided content closure, which receives an `AsyncImagePhase` representing
/// the different states of the asynchronous image loading process.
///
/// - Parameters:
///   - url: The URL of the image to display
///   - scale: The scale to use for the image. The default is 1
///   - transaction: The transaction to use when the phase changes
///   - content: A closure that takes the load phase as an input, and returns the view to display for the specified phase
struct CachedAsyncImage<Content: View>: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    @ViewBuilder private let content: (AsyncImagePhase) -> Content

    init(url: URL,
         scale: CGFloat = 1,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View {
        if let cachedImage = ImageCache[url] {
            content(.success(cachedImage))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheIfNeeded(usingPhase: phase)
            }
        }
    }
    
    /// Caches the image associated with the provided async image phase if the loading was successful and returns the content associated with the phase
    ///
    /// - Parameter phase: The phase of the asynchronous image loading process
    ///
    /// - Returns: An image
    private func cacheIfNeeded(usingPhase phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}
