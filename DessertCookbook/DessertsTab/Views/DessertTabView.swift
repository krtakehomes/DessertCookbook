//
//  DessertTabView.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

/// A tab view that displays a list of tappable desserts that can navigate the user to a detail view with in-depth information pertaining to the dessert
struct DessertTabView: View {
    @ObservedObject private var viewModel = DessertTabViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.desserts) { dessert in
                // This ZStack hides the chevron that List applies to row views
                ZStack {
                    NavigationLink(value: dessert) {
                        EmptyView()
                    }
                    .opacity(0)
                         
                    DessertCardView(dessert: dessert)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    Task {
                        await didTapDessert(dessert)
                    }
                }
                .alert(viewModel.detailViewNetworkErrorAlert.title, isPresented: $viewModel.isShowingDetailViewNetworkErrorAlert) {
                    Button(viewModel.detailViewNetworkErrorAlert.primaryActionLabel) {
                        viewModel.isShowingDetailViewNetworkErrorAlert = false
                    }
                } message: {
                    Text(viewModel.detailViewNetworkErrorAlert.message)
                }
                .alert(viewModel.badRecipeErrorAlert.title, isPresented: $viewModel.isShowingBadRecipeErrorAlert) {
                    Button(viewModel.badRecipeErrorAlert.primaryActionLabel) {
                        viewModel.isShowingBadRecipeErrorAlert = false
                    }
                } message: {
                    Text(viewModel.badRecipeErrorAlert.message)
                }
            }
            .listRowSpacing(16)
            .listStyle(.plain)
            .background(Color.background)
            .navigationTitle(viewModel.tabTitle)
            .navigationDestination(item: $viewModel.selectedDessert) {
                DessertDetailView(viewModel: DessertDetailViewModel(dessert: $0))
            }
            .overlay {
                if viewModel.isShowingDetailViewSpinner {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .alert(viewModel.listNetworkErrorAlert.title, isPresented: $viewModel.isShowingListNetworkErrorAlert) {
                Button(viewModel.listNetworkErrorAlert.primaryActionLabel) { 
                    viewModel.isShowingListNetworkErrorAlert = false
                }
            } message: {
                Text(viewModel.listNetworkErrorAlert.message)
            }
            .task {
                await viewModel.fetchDesserts()
            }
            .refreshable {
                await viewModel.fetchDesserts()
            }
        }
        .tabItem {
            Label(viewModel.tabTitle, systemImage: viewModel.tabItemImageName)
        }
    }
    
    /// Handles the user's tap on a dessert by fetching its information to be displayed in its detail view
    ///
    /// - Parameter dessert: The tapped dessert
    func didTapDessert(_ dessert: Dessert) async {
        await viewModel.fetchDetails(forDessert: dessert)
    }
}

#Preview {
    DessertTabView()
}
