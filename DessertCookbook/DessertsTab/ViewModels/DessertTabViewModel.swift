//
//  DessertTabViewModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import Foundation

/// A class that manages the data, user interaction, and presentation logic for a ``DessertTabView``
class DessertTabViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var selectedDessert: Dessert?
    @Published var isShowingDetailViewSpinner = false
    @Published var isShowingListNetworkErrorAlert = false
    @Published var isShowingDetailViewNetworkErrorAlert = false
    @Published var isShowingBadRecipeErrorAlert = false
    let tabTitle = "Desserts"
    let tabItemImageName = "birthday.cake"
    
    /// Fetches all of the available desserts from ``NetworkService/TheMealDB`` endpoint _and_ uses the response to populate the ``desserts`` array
    @MainActor func fetchDesserts() async {
        let response: Result = await NetworkService.TheMealDB.getDesserts()
        
        switch response {
            case .success(let containerDataModel):
                let dessertDataModels: [DessertDataModel] = containerDataModel.dataModels
                let desserts: [Dessert] = dessertDataModels
                    .compactMap { dataModel in
                        // Do not store the dessert if its name is missing
                        guard !dataModel.name.isEmpty else {
                            return nil
                        }
                        
                        return Dessert(id: dataModel.id, name: dataModel.name.localizedCapitalized, imageURLString: dataModel.imageURLString)
                    }
                    .sorted { $0.name < $1.name }
                
                self.desserts = desserts
            case .failure(let failure):
                // If a network error occurred while fetching the desserts and the desserts array is empty, show an error alert
                isShowingListNetworkErrorAlert = desserts.isEmpty
                print(failure)
        }
    }
    
    /// Fetches detailed information for the provided dessert from ``NetworkService/TheMealDB`` endpoint _and_ uses the response to set the ``selectedDessert``
    ///
    /// - Parameter dessert: The dessert for which to fetch detailed information
    @MainActor func fetchDetails(forDessert dessert: Dessert) async {
        isShowingDetailViewSpinner = true
        
        let response: Result = await NetworkService.TheMealDB.getDessertInfo(byID: dessert.id)
        
        switch response {
            case .success(let containerDataModel):
                isShowingDetailViewSpinner = false
                
                // Ensure that the response contains the dessert information
                guard let dessertInfoDataModel = containerDataModel.dataModels.first else {
                    isShowingBadRecipeErrorAlert = true
                    return
                }
                
                let ingredientNames: [String] = dessertInfoDataModel.ingredientNames
                let ingredientMeasurements: [String] = dessertInfoDataModel.ingredientMeasurements
                
                // Ensure that there are an equal number of ingredient names and measurements
                if ingredientNames.count != ingredientMeasurements.count {
                    isShowingBadRecipeErrorAlert = true
                    return
                }
                
                let ingredients: [DessertIngredient] = zip(ingredientNames, ingredientMeasurements).compactMap {
                    // Do not build the DessertIngredient model if its name or measurement are missing
                    if $0.isEmpty || $1.isEmpty {
                        return nil
                    } else {
                        return DessertIngredient(name: $0, measurement: $1)
                    }
                }
                
                // After building the DessertIngredient models, ensure that there are in fact ingredients
                if ingredients.isEmpty {
                    isShowingBadRecipeErrorAlert = true
                    return
                }
                
                var selectedDessert: Dessert = dessert
                selectedDessert.origin = dessertInfoDataModel.origin
                selectedDessert.instructions = dessertInfoDataModel.instructions
                selectedDessert.ingredients = ingredients
                
                self.selectedDessert = selectedDessert
            case .failure(let failure):
                // Show an error alert because a network error occurred while fetching the dessert information
                isShowingDetailViewSpinner = false
                isShowingDetailViewNetworkErrorAlert = true
                print(failure)
        }
    }
}

extension DessertTabViewModel {
    /// The error alert shown if desserts are unable to be fetched
    var listNetworkErrorAlert: AlertInfo {
        AlertInfo(title: "Unable To Load Desserts",
                  message: "Please check your network and try again.",
                  primaryActionLabel: "OK"
        )
    }
    
    /// The error alert shown if a dessert's information is unable to be fetched
    var detailViewNetworkErrorAlert: AlertInfo {
        AlertInfo(title: "Unable To Load Recipe",
                  message: "Please check your network and try again.",
                  primaryActionLabel: "OK"
        )
    }
    
    /// The error alert shown if a dessert's information is considered bad
    var badRecipeErrorAlert: AlertInfo {
        AlertInfo(title: "Recipe Not Available",
                  message: "Please check back soon.",
                  primaryActionLabel: "OK"
        )
    }
}
