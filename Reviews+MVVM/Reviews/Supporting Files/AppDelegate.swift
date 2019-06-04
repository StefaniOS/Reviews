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
    var networkManager: NetworkManager!
    var reviewsViewModel: ReviewsViewModel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let navigationViewcontroller = window?.rootViewController as? UINavigationController,
            let reviewsViewController = navigationViewcontroller.topViewController as? ReviewsViewController
        {
            // TODO: Use dependency injection factory here
            networkManager = NetworkManager()
            reviewsViewModel = ReviewsViewModel(networkManager: networkManager, delegate: reviewsViewController)
            reviewsViewController.viewModel = reviewsViewModel
        }
        
        return true
    }
}

