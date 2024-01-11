//
//  DessertInfoDataModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

/// The data model representing the _detailed_ information pertaining to a dessert
struct DessertInfoDataModel: Decodable {
    let origin: String
    let instructions: String
    private(set) var ingredientNames: [String] = []
    private(set) var ingredientMeasurements: [String] = []
    
    private enum CodingKeys: String, CodingKey {
        case instructions = "strInstructions"
        case origin = "strArea"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        origin = try container.decodeIfPresent(String.self, forKey: CodingKeys.origin) ?? ""
        instructions = try container.decodeIfPresent(String.self, forKey: CodingKeys.instructions) ?? ""
        
        let ingredients: (names: [String], measurements: [String]) = try decodeIngredientKeys(from: decoder)
        ingredientNames = ingredients.names
        ingredientMeasurements = ingredients.measurements
    }
    
    /// Decodes the ingredient keys from the provided decoder
    ///
    /// - Returns: A tuple containing arrays for the dessert's ingredient names and measurements
    private func decodeIngredientKeys(from decoder: Decoder) throws -> (names: [String], measurements: [String]) {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        var ingredientNameKeyStrings: [String] = []
        var measurementKeyStrings: [String] = []
        
        // Find all keys that begin with the known ingredient and measure prefixes
        for key in container.allKeys {
            if key.stringValue.hasPrefix(ingredientKeyPrefix) {
                ingredientNameKeyStrings.append(key.stringValue)
            }

            if key.stringValue.hasPrefix(measurementKeyPrefix) {
                measurementKeyStrings.append(key.stringValue)
            }
        }
        
        // Sort the key strings in place by ascending order so that strings at the same index in each array are associated
        ingredientNameKeyStrings.sort()
        measurementKeyStrings.sort()
        
        let ingredientNames: [String] = try ingredientNameKeyStrings.compactMap {
            guard let ingredientNameKey = CustomCodingKeys(stringValue: $0) else {
                return nil
            }
            
            return try container.decodeIfPresent(String.self, forKey: ingredientNameKey) ?? ""
        }
        
        let measurementNames: [String] = try measurementKeyStrings.compactMap {
            guard let measurementKey = CustomCodingKeys(stringValue: $0) else {
                return nil
            }
            
            return try container.decodeIfPresent(String.self, forKey: measurementKey) ?? ""
        }
        
        return (ingredientNames, measurementNames)
    }
}

private extension DessertInfoDataModel {
    /// The prefix string for an ingredient key string value
    var ingredientKeyPrefix: String {
        "strIngredient"
    }
    
    /// The prefix string for a measurement key string value
    var measurementKeyPrefix: String {
        "strMeasure"
    }
    
    /// A coding key that is defined by a string literal
    private struct CustomCodingKeys: CodingKey {
        var stringValue: String

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?

        init?(intValue: Int) {
            return nil
        }
    }
}
