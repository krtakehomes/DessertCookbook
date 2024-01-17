//
//  CacheableImage.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/15/24.
//

import SwiftUI

/// A view that asynchronously loads and caches images from a specified URL
///
/// Use `CachedAsyncImage` to request and load images asynchronously from a specified URL and cache them using SwiftData for more performant
/// subsequent retrievals. The cached images are stored using ``ImageCache``.
///
/// - Parameters:
///   - url: The URL of the image to load
///   - timeoutInterval: The maximum time allowed for fetching the image. Defaults to 5 seconds
///   - completion: A closure that transforms the successfully loaded image into content to be displayed
///   - loadingContent: The content to be displayed during the image loading phase
///   - errorContent: The content to be displayed in case of an error during image loading
struct CachedAsyncImage<LoadingContent: View, ErrorContent: View, ImageContent: View>: View {
    @State private var imagePhase: CachedAsyncImagePhase = .loading
    @ViewBuilder private var completion: (Image) -> (ImageContent)
    @ViewBuilder private var loadingContent: LoadingContent
    @ViewBuilder private var errorContent: ErrorContent
    private let url: URL?
    private let timeoutInterval: Double
    
    init(url: URL?, 
         timeoutInterval: Double = 5,
         @ViewBuilder completion: @escaping (Image) -> (ImageContent),
         @ViewBuilder loadingContent: () -> LoadingContent,
         @ViewBuilder errorContent: () -> ErrorContent
    ) {
        self.url = url
        self.timeoutInterval = timeoutInterval
        self.completion = completion
        self.loadingContent = loadingContent()
        self.errorContent = errorContent()
    }
    
    var body: some View {
        // Wrap the group in a geometry reader so that the call site can specify the view's frame size
        GeometryReader { geometryProxy in
            Group {
                switch imagePhase {
                    case .loading:
                        loadingContent
                    case .rendered(let image):
                        completion(image)
                    case .error:
                        errorContent
                }
            }
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
        }
        .task {
            await fetchImage(url)
        }
    }
    
    /// Fetches the image from the provided URL and updates the image phase accordingly
    ///
    /// - Parameter url: The URL of the image to fetch
    @MainActor private func fetchImage(_ url: URL?) async {
        guard let url else {
            imagePhase = .error
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeoutInterval
        
        let urlString = url.absoluteString
        
        if let cachedImage = ImageCache.shared.getImageView(for: urlString) {
            imagePhase = .rendered(image: cachedImage)
        } else {
            do {
                let (imageData, response) = try await URLSession.shared.data(for: urlRequest)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    imagePhase = .error
                    return
                }
                
                guard let uiImage = UIImage(data: imageData) else {
                    imagePhase = .error
                    return
                }
                
                imagePhase = .rendered(image: Image(uiImage: uiImage))
                ImageCache.shared.add(CacheableImageModel(urlString: urlString, data: imageData))
            } catch {
                imagePhase = .error
            }
        }
    }
}

extension CachedAsyncImage {
    /// A phase during the image loading process in ``CachedAsyncImage``
    private enum CachedAsyncImagePhase: Equatable {
        case loading
        case rendered(image: Image)
        case error
    }
}

//#Preview {
//    CacheableImage()
//}
