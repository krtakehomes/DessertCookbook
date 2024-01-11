//
//  MealsContainerDataModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import Foundation

/// The data model representing the meals object container in a standard response from ``NetworkService/TheMealDB``
struct MealsContainerDataModel<DataModel: Decodable>: Decodable {
    let dataModels: [DataModel]
    
    private enum CodingKeys: String, CodingKey {
        case meals
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dataModels = try container.decode([DataModel].self, forKey: .meals)
    }
}
