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
    
    init(dessert: Dessert) {
        self.dessert = dessert
    }
    
    var image: Image {
        if let imageURL = URL(string: dessert.imageURLString), let image = ImageCache.cache[imageURL] {
            return image
        } else {
            return Image(systemName: "photo")
        }
    }
    
    var name: String {
        dessert.name
    }
    
    var origin: String {
        dessert.origin ?? ""
    }
    
    var instructions: String {
        dessert.instructions ?? ""
    }
    
    var ingredients: [DessertIngredient] {
        dessert.ingredients
    }
}
