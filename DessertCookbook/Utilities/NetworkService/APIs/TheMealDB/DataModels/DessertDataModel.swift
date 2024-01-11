//
//  DessertDataModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import Foundation

/// The data model representing the _basic_ information pertaining to a dessert
struct DessertDataModel: Decodable, Hashable {
    let id: String
    let name: String
    let imageURLString: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageURLString = "strMealThumb"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        imageURLString = try container.decodeIfPresent(String.self, forKey: .imageURLString) ?? ""
    }
}
