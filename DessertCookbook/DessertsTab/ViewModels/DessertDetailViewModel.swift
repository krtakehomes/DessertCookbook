//
//  DessertDetailViewModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

/// A class that manages the data, user interaction, and presentation logic for a ``DessertDetailView``
class DessertDetailViewModel: ObservableObject {
    @Published private var dessert: Dessert
    @Published var isShowingIngredients = true
    @Published private var isBookmarked: Bool
    let ingredientsLabel = "Ingredients"
    private let defaultImageName = "photo"
    
    init(dessert: Dessert) {
        self.dessert = dessert
        self.isBookmarked = BookmarkManager.shared.isBookmarked(dessertID: dessert.id) // Set the initial bookmark state
    }
    
    var image: Image {
        ImageCache.shared.getImageView(for: dessert.imageURLString) ?? Image(systemName: defaultImageName)
    }
    
    var name: String {
        dessert.name
    }
    
    var bookmarkImageName: String {
        isBookmarked ? "bookmark.fill" : "bookmark"
    }
    
    var origin: String {
        dessert.origin
    }
    
    var showOrigin: Bool {
        return !dessert.origin.isEmpty
    }
    
    var instructions: String {
        dessert.instructions
    }
    
    var ingredients: [DessertIngredient] {
        dessert.ingredients
    }
    
    /// Handles the user's tap on the bookmark button by toggling the bookmarked state of the current dessert
    func didTapBookmarkButton() {
        BookmarkManager.shared.toggleBookmark(for: dessert) { isBookmarked in
            self.isBookmarked = isBookmarked
        }
    }
}
