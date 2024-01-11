//
//  Dessert.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import Foundation

/// A dessert
///
/// - Parameters:
///   - id: The id of the dessert
///   - name: The name of the dessert
///   - origin: The origin of the dessert
///   - instructions: The instructions detailing how to make the dessert
///   - ingredients: The ingredients needed to make the dessert
///   - imageURLString: The string for the dessert's image URL
struct Dessert: Identifiable, Hashable {
    let id: String
    let name: String
    var origin: String? = nil
    var instructions: String? = nil
    var ingredients: [DessertIngredient] = []
    let imageURLString: String
}
