//
//  NetworkService+TheMealDB.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import Foundation

extension NetworkService {
    /// The API for TheMealDB
    struct TheMealDB {
        private enum Endpoint: EndpointProtocol {
            case desserts
            case dessertInfo(dessertID: String)
            
            var url: URL? {
                switch self {
                    case .desserts:
                        return URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
                    case .dessertInfo(let dessertID):
                        return URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(dessertID)")
                }
            }
        }
        
        /// Retrieves the dessert list from TheMealDB
        ///
        /// - Returns: A result containing a dessert list container data model or an error if the request fails
        static func getDesserts() async -> Result<MealsContainerDataModel<DessertDataModel>, NetworkServiceError> {
            guard let url = Endpoint.desserts.url else {
                return .failure(.malformedURL)
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 2
            
            return await NetworkService.sendRequest(urlRequest)
        }
        
        /// Retrieves detailed information for a dessert matching the provided ID
        ///
        /// - Parameter dessertID: The ID of the dessert for which to receive detailed information
        ///
        /// - Returns: A result containing a dessert information container data model or an error if the request fails
        static func getDessertInfo(byID dessertID: String) async -> Result<MealsContainerDataModel<DessertInfoDataModel>, NetworkServiceError> {
            guard let url = Endpoint.dessertInfo(dessertID: dessertID).url else {
                return .failure(.malformedURL)
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 2
            
            return await NetworkService.sendRequest(urlRequest)
        }
    }
}
