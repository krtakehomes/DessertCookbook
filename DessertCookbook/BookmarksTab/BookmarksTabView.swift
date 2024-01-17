//
//  BookmarksTabView.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/13/24.
//

import SwiftUI

// A tab view that displays a list of bookmarked desserts that can be tapped to navigate the user to a detail view with in-depth information pertaining to the dessert
struct BookmarksTabView: View {
    @StateObject var viewModel = BookmarksTabViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.bookmarks) { dessert in
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
                    viewModel.didTapBookmark(dessert)
                }
            }
            .listRowSpacing(16)
            .listStyle(.plain)
            .background(Color.background)
            .navigationTitle(viewModel.tabTitle)
            .navigationDestination(item: $viewModel.selectedBookmark) {
                DessertDetailView(viewModel: DessertDetailViewModel(dessert: $0))
            }
            .overlay {
                if viewModel.isShowingNoBookmarksText {
                    Text(viewModel.noBookmarksString)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
        }
        .tabItem {
            Label(viewModel.tabTitle, systemImage: viewModel.tabItemImageName)
        }
    }
}
