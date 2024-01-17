//
//  ImageCache.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/13/24.
//

import SwiftUI
import SwiftData

/// A singleton class responsible for caching and managing images using SwiftData
///
/// - Note: The cache is automatically refreshed on Mondays to ensure data consistency
class ImageCache: ObservableObject {
    @MainActor static let shared = ImageCache()
    private let modelContext: ModelContext
    
    /// The date when the cache was last refreshed
    private var lastRefreshDate: Date!
    
    /// The UserDefaults key for storing the last refresh date
    private let lastRefreshDateKey = "imageCacheLastRefreshDate"

    @MainActor private init() {
        let modelContainer = try! ModelContainer(for: CacheableImageModel.self)
        self.modelContext = modelContainer.mainContext
         
        if let lastRefreshDate = getLastRefreshDate() {
            self.lastRefreshDate = lastRefreshDate
        } else {
            updateLastRefreshDate()
        }
    }
    
    /// Adds an image to the cache
    ///
    /// - Parameter image: The model representing the image to be cached
    func add(_ image: CacheableImageModel) {
        modelContext.insert(image)
    }
    
    /// Retrieves the image associated with the specified URL string from the cache
    ///
    /// - Parameter urlString: The URL string of the desired image
    ///
    /// - Returns: An image if it is found in the cache; otherwise, `nil`
    func getImageView(for urlString: String) -> Image? {
        var image: Image?
        
        let fetchDescriptor = FetchDescriptor<CacheableImageModel>(predicate: #Predicate { image in
            image.urlString == urlString
        })
        
        do {
            if let imageData = try modelContext.fetch(fetchDescriptor).first?.data {
                if let uiImage = UIImage(data: imageData) {
                    image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print("Image not found in cache")
            return nil
        }
        
        return image
    }
    
    /// Refreshes the cache if the current day is Monday and it has _not_ already been refreshed
    ///
    /// This function is called in ``AppDelegate`` during app launch and when the application enters the foreground.
    /// Refreshing the cache allows us to keep its size reasonably small if our image sources continuously change.
    ///
    /// - Note: If our image sources begin to change more often, we can increase the frequency in which the cache is refreshed
    /// (i.e., more than just on Mondays)
    func refreshIfNecessary() {
        let calendar: Calendar = Calendar.current
        let wasRefreshedToday = calendar.isDateInToday(lastRefreshDate)
        let isTodayMonday = calendar.component(.weekday, from: Date()) == 2
        
        if !wasRefreshedToday && isTodayMonday {
            do {
                try modelContext.delete(model: CacheableImageModel.self)
            } catch {
                print("Error refreshing cache")
            }
            
            updateLastRefreshDate()
        }
    }
    
    /// Updates the last refresh date to today in UserDefaults
    private func updateLastRefreshDate() {
        let today: Date = Date.now
        lastRefreshDate = today
        UserDefaults.standard.setValue(today, forKey: lastRefreshDateKey)
    }
    
    /// Retrieves the last refresh date from UserDefaults
    ///
    /// - Returns: The last refresh date if available; otherwise, `nil`
    private func getLastRefreshDate() -> Date? {
        UserDefaults.standard.value(forKey: lastRefreshDateKey) as? Date
    }
}
