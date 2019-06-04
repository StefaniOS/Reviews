//
//  AppDelegate.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var networkManager: NetworkManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        networkManager = NetworkManager()
        
        if let navigationViewcontroller = window?.rootViewController as? UINavigationController,
            let reviewsViewController = navigationViewcontroller.topViewController as? ReviewsViewController
        {
            reviewsViewController.networkManager = networkManager
        }
        
        return true
    }
}

