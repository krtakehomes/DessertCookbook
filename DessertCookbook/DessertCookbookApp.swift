//
//  DessertCookbookApp.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/10/24.
//

import SwiftUI

@main
struct DessertCookbookApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
