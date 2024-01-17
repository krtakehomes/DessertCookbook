//
//  CacheableImageModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/15/24.
//

import Foundation
import SwiftData

/// A SwiftData model representing a cached image
@Model class CacheableImageModel {
    let urlString: String
    let data: Data
    
    /// - Parameters:
    ///   - urlString: The URL string of the image
    ///   - data: The raw data of the image
    init(urlString: String, data: Data) {
        self.urlString = urlString
        self.data = data
    }
}
