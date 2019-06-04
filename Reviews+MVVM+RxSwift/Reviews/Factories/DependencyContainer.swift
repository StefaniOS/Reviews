//
//  DependencyContainer.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 03.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation

typealias Factory = ViewControllerFactory & ServiceFactory & ViewModelFactory

protocol ViewControllerFactory {
    func makeHomeViewController() -> HomeViewController
    func makeReviewsViewController() -> ReviewsViewController
}

protocol ViewModelFactory {
    var reviewsViewModel: ReviewsViewModel { get }
}

protocol ServiceFactory {
    var networkManager: NetworkManager { get }
}

class DependencyContainer: ServiceFactory, ViewModelFactory {
    internal lazy var networkManager = NetworkManager()
    internal lazy var reviewsViewModel = ReviewsViewModel(self)
}

// A new instance is created by each call of these methods
extension DependencyContainer: ViewControllerFactory {
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(self)
    }
    
    func makeReviewsViewController() -> ReviewsViewController {
        return ReviewsViewController(self)
    }
}
