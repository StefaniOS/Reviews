//
//  ViewController.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let reviewsViewModel: ReviewsViewModel!
    private let reviewsViewController: ReviewsViewController!
    
    init(_ factory: Factory) {
        
        reviewsViewController = factory.makeReviewsViewController()
        reviewsViewModel = factory.reviewsViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavBar()
        setupSubviews()
        
        loadData()
    }
    
    func loadData() {
        reviewsViewModel.fetchReviews()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.barTintColor = UIColor.Custom.green
        navigationItem.title = "Reviews"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSubviews() {
        let reviewView = reviewsViewController.view!
        
        addChild(reviewsViewController)
        view.addSubview(reviewView)
        reviewsViewController.didMove(toParent: self)
        
        let safeArea = view.safeAreaLayoutGuide
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        reviewView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        reviewView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        reviewView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        reviewView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
}
