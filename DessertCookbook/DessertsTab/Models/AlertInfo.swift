//
//  AlertInfo.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/9/24.
//

import Foundation

/// Information describing an alert that is to be presented to the user
///
/// - Parameters:
///   - title: The title of the alert
///   - message: The message to display in the body of the alert
///   - primaryActionLabel: The label for the alert's primary action button
struct AlertInfo {
    let title: String
    let message: String
    let primaryActionLabel: String
}
