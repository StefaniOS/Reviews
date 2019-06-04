//
//  ViewController.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit
import Alamofire

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.prefetchDataSource = self
            tableView.dataSource = self
        }
    }
    
    // Dependency Injection
    var viewModel: ReviewsViewModel! {
        didSet {
            viewModel.fetchReviews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationItem.title = "Reviews"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.barTintColor = UIColor.Custom.blue
    }
}

// MARK: TableView DataSource
extension ReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReviewCell.self)", for: indexPath) as! ReviewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            let reviewViewModel = viewModel.reviewViewModel(at: indexPath.row)
            cell.configure(with: reviewViewModel)
        }
        
        return cell
    }
}

// MARK: Prefetching DataSource
extension ReviewsViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        if indexPaths.contains(where: isLoadingCell) {
            fetchNextPage()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        print("cancelPrefetchingForRowsAt \(indexPaths)")
    }
}

// MARK: ReviewsViewModelDelegate
extension ReviewsViewController: ReviewsViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        alert(message: reason)
    }
}

// MARK: Fetch helpers
extension ReviewsViewController {
    
    func fetchNextPage() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.viewModel.fetchReviews()
        }
    }
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

