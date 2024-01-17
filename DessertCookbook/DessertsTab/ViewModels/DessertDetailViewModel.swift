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
    let ingredientsLabel = "Ingredients"
    private let defaultImageName = "photo"
    
    init(dessert: Dessert) {
        self.dessert = dessert
    }
    
    var image: Image {
        ImageCache.shared.getImageView(for: dessert.imageURLString) ?? Image(systemName: defaultImageName)
    }
    
    var name: String {
        dessert.name
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
}
