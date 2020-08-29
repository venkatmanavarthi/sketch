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
            let Yours = UINavigationController(rootViewController: PrimaryDrawingViewController())
            let sharedDrawingVc = UINavigationController(rootViewController: SharingViewController())
            let mainVc = UITabBarController()
            mainVc.viewControllers = [Yours,sharedDrawingVc]
            mainVc.selectedViewController = Yours
            Yours.tabBarItem = self.setTabBarItem(with: "brush")
            Yours.title = "Your Drawing"
            sharedDrawingVc.tabBarItem = self.setTabBarItem(with: "folder")
            sharedDrawingVc.title = "Sharing"
            window?.rootViewController = mainVc
        }else{
            window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        }
        window?.makeKeyAndVisible()
        return true
    }
    func setTabBarItem(with icon : String) -> UITabBarItem{
        let item = UITabBarItem()
        item.image = UIImage(named: icon)
//        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item.title = nil
        return item
    }
}

