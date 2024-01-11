//
//  DessertDetailView.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

/// A view that shows in-depth details about a dessert, such as its instructions and ingredients
struct DessertDetailView: View {
    @ObservedObject var viewModel: DessertDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                viewModel.image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipped()
                
                VStack(spacing: 16) {
                    VStack {
                        Text(viewModel.name)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        
                        if viewModel.showOrigin {
                            Text(viewModel.origin)
                                .font(.caption)
                        }
                    }
                        
                    ExpandableCardView(isExpanded: $viewModel.isShowingIngredients) {
                        Text(viewModel.ingredientsLabel)
                            .fontWeight(.bold)
                    } content: {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.ingredients) { ingredient in
                                Text(ingredient.name)
                                    .fontWeight(.medium)
                                +
                                Text(" - \(ingredient.measurement)")
                            }
                        }
                        .padding(.leading)
                    }
                    .tint(.black)
                    
                    Text(viewModel.instructions)
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color.background)
        .toolbarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    DessertDetailView(
        viewModel: DessertDetailViewModel(
            dessert: Dessert(id: "1",
                             name: "Lorem Ipsum",
                             origin: "Lorem Ipsum",
                             instructions: "Lorem Ipsum",
                             ingredients: [DessertIngredient(id: UUID(), name: "Lorem Ipsum", measurement: "Lorem Ipsum")],
                             imageURLString: "")
        )
    )
}
