//
//  ImageCache.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

/// A simple in-memory cache for storing and retrieving images based on their URLs
class ImageCache {
    /// The shared cache instance that holds the mapping of URLs to images
    static var cache: [URL: Image] = [:]

    /// Provides subscript access to the cached images based on their URLs
    ///
    /// - Parameter url: The URL of the image to retrieve or store
    /// - Returns: The image associated with the provided URL, or `nil` if not found
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
