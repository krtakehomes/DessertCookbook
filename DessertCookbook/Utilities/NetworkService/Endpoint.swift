//
//  Endpoint.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/10/24.
//

import Foundation

/// An API endpoint
protocol EndpointProtocol {
    /// A URL for this endpoint
    var url: URL? { get }
}
