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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let factory = DependencyContainer()
        let homeViewController = factory.makeHomeViewController()
        let navigationViewController = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

