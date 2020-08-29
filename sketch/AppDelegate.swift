//
//  AppDelegate.swift
//  sketch
//
//  Created by manavarthivenkat on 27/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        if Auth.auth().currentUser != nil{
            window?.rootViewController = UINavigationController(rootViewController: SlateViewController())
        }else{
            window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        }
        window?.makeKeyAndVisible()
        return true
    }
}

