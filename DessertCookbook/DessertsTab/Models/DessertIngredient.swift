//
//  DessertIngredient.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/9/24.
//

import Foundation

/// A dessert ingredient
///
/// - Parameters:
///   - id: The ID of the ingredient
///   - name: The name of the ingredient
///   - measurement: The quantity of the ingredient
struct DessertIngredient: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let measurement: String
}
