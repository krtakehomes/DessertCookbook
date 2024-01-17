//
//  BookmarksTabViewModel.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/13/24.
//

import Foundation
import Combine

/// A class that manages the data, user interaction, and presentation logic for a ``BookmarksTabView``
class BookmarksTabViewModel: ObservableObject {
    @Published var bookmarks: [Dessert] = []
    @Published var selectedBookmark: Dessert?
    let tabTitle = "Bookmarks"
    let tabItemImageName = "bookmark"
    let noBookmarksString = "Looks like you don't have any bookmarks yet!\n\nVisit a dessert's recipe page and tap the bookmark button to save it for later."
    
    /// Set of cancellables to manage Combine bookmark subscriptions
    private var cancellables: Set<AnyCancellable> = []

    init() {
        // Observe changes in the BookmarkManager's bookmarks using Combine and update our bookmarks property
        BookmarkManager.shared.$bookmarks.sink(receiveValue: { newBookmarks in
            self.bookmarks = newBookmarks.values.sorted(by: { $0.name < $1.name })
        })
        .store(in: &cancellables)
    }
    
    var isShowingNoBookmarksText: Bool {
        bookmarks.isEmpty
    }
    
    /// Handles the user's tap on a bookmarked dessert by setting it as the selected dessert
    ///
    /// - Parameter dessert: The tapped dessert
    func didTapBookmark(_ dessert: Dessert) {
        selectedBookmark = dessert
    }
}
