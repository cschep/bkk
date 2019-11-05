//
//  BKKAppDelegate.swift
//  baby ketten
//
//  Created by Christopher Schepman on 7/13/19.
//

import UIKit

@UIApplicationMain
class BKKAppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        UINavigationBar.appearance().tintColor = .systemRed
        UITabBar.appearance().tintColor = .systemRed
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
