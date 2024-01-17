//
//  BookmarkManager.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/13/24.
//

import Foundation

/// A singleton class responsible for managing and persisting bookmarked desserts in UserDefaults
class BookmarkManager: ObservableObject {
    @Published private(set) var bookmarks: [String: Dessert] = [:]
    static let shared = BookmarkManager()
    private let bookmarksKey = "bookmarks"
    
    private init() {
        bookmarks = getBookmarks()
    }
    
    /// Returns `true` if a dessert with the specified ID is bookmarked
    ///
    /// - Parameter dessertID: The ID of the dessert for which to check its bookmark status
    ///
    /// - Returns: `true` if a dessert with the specified ID is bookmarked
    func isBookmarked(dessertID: String) -> Bool {
        return bookmarks[dessertID] != nil
    }
    
    /// Toggles the bookmark status for the specified dessert and updates UserDefaults
    ///
    /// - Parameters:
    ///   - dessert: The dessert for which to toggle the bookmark status
    ///   - completion: A closure called after the bookmark status is toggled that returns a boolean indicating the dessert's updated bookmark status
    func toggleBookmark(for dessert: Dessert, completion: @escaping (Bool) -> ()) {
        let isCurrentlyBookmarked = bookmarks[dessert.id] != nil
        
        bookmarks[dessert.id] = isCurrentlyBookmarked ? nil : dessert
        
        if let encodedBookmarks = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encodedBookmarks, forKey: bookmarksKey)
        }
        
        completion(!isCurrentlyBookmarked)
    }
    
    /// Retrieves bookmarked desserts from UserDefaults
    ///
    /// - Returns: Bookmarked desserts
    private func getBookmarks() -> [String: Dessert] {
        if let encodedBookmarks = UserDefaults.standard.data(forKey: bookmarksKey),
           let bookmarks = try? JSONDecoder().decode([String: Dessert].self, from: encodedBookmarks) {
            return bookmarks
        } else {
            return [:]
        }
    }
}
