//
//  NetworkService.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import Foundation

/// A service that handles network requests and errors during API interactions
///
/// - Note: Extend this class with an inner-struct for each new API the application consumes
class NetworkService {
    /// A network request error
    enum NetworkServiceError: Error {
        case malformedURL
        case requestFailed
        case decodingError
    }
    
    /// Sends the provided request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - request: The request to be sent
    ///
    /// - Returns: A result containing a decoded response or an error if the request fails
    static func sendRequest<DecodableType: Decodable>(_ request: URLRequest) async -> Result<DecodableType, NetworkServiceError> {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let jsonDecoder = JSONDecoder()

            do {
                let decodedResponse: DecodableType = try jsonDecoder.decode(DecodableType.self, from: data)
                return .success(decodedResponse)
            } catch let decodingError as DecodingError {
                print("**** NetworkManager Error @ \(#function) ****")
                print("\tDescription: \(decodingError)")
                print("\n\tResponse Data: \(String(data: data, encoding: .utf8) ?? "nil")")
                return .failure(.decodingError)
            }
        } catch {
            return .failure(.requestFailed)
        }
    }
}
