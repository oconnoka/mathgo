//
//  AppDelegate.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 1/19/22.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var player: Player! = Player()
    var playerExists: Bool!

    func setPlayerExists(value: Bool) {
        playerExists = value
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let dataStore = UserDefaults.standard
        
        // Check if player exists, returns false if key doesn't exist
        playerExists = dataStore.bool(forKey: "playerExists")
        if (!playerExists) {
            dataStore.set(true, forKey: "playerExists")
            try? dataStore.setObject(self.player, forKey: "player")
        }
        
        // Load player data
        guard let playerData = try? dataStore.getObject(forKey: "player", castTo: Player.self) else {
            print("no playerData")
            return true
        }

        self.player = playerData

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

