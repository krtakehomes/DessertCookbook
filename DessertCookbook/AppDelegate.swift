//
//  AppDelegate.swift
//  DessertCookbook
//
//  Created by Kyle Ronayne on 1/15/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ImageCache.shared.refreshIfNecessary()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        ImageCache.shared.refreshIfNecessary()
    }
}
