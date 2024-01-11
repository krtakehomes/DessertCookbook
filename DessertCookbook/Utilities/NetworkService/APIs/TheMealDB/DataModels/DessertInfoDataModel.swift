//
//  DessertInfoDataModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

/// The data model representing the _detailed_ information pertaining to a dessert
struct DessertInfoDataModel: Decodable {
    let instructions: String
    private(set) var ingredients: [DessertIngredient] = []
    let origin: String
    
    private enum CodingKeys: String, CodingKey {
        case instructions = "strInstructions"
        case origin = "strArea"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        instructions = try container.decodeIfPresent(String.self, forKey: CodingKeys.instructions) ?? ""
        origin = try container.decodeIfPresent(String.self, forKey: CodingKeys.origin) ?? ""
        ingredients = try decodeIngredientKeys(from: decoder)
    }
    
    /// Decodes the ingredient keys from the provided decoder
    ///
    /// - Returns: An array of dessert ingredients created from the decoded keys
    private func decodeIngredientKeys(from decoder: Decoder) throws -> [DessertIngredient] {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        var ingredientKeyStrings: [String] = []
        var measurementKeyStrings: [String] = []
        
        // Find all keys that begin with the known ingredient and measure prefixes
        for key in container.allKeys {
            if key.stringValue.hasPrefix(ingredientKeyPrefix) {
                ingredientKeyStrings.append(key.stringValue)
            }

            if key.stringValue.hasPrefix(measurementKeyPrefix) {
                measurementKeyStrings.append(key.stringValue)
            }
        }
        
        // Sort the key strings in place by ascending order
        ingredientKeyStrings.sort { $0 < $1 }
        measurementKeyStrings.sort { $0 < $1 }
        
        return try zip(ingredientKeyStrings, measurementKeyStrings).compactMap { (ingredientKeyString, measurementKeyString) in
            guard let ingredientKey = CustomCodingKeys(stringValue: ingredientKeyString),
                  let measurementKey = CustomCodingKeys(stringValue: measurementKeyString) else {
                return nil
            }
            
            let ingredientName: String = try container.decodeIfPresent(String.self, forKey: ingredientKey) ?? ""
            let ingredientMeasurement: String = try container.decodeIfPresent(String.self, forKey: measurementKey) ?? ""
            
            return DessertIngredient(name: ingredientName, measurement: ingredientMeasurement)
        }
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
