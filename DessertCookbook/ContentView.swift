//
//  ContentView.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Group {
                DessertTabView()
                BookmarksTabView()
            }
            .toolbarColorScheme(.light, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
