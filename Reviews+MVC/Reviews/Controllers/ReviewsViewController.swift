//
//  ViewController.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.prefetchDataSource = self
            tableView.refreshControl = refreshControl
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let tintColor: UIColor = .red
        refreshControl.tintColor = tintColor
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    var networkManager: NetworkManager!
    
    private var total = 0
    private var currentPage = 0
    private var isFetchInProgress = false
    
    fileprivate var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        fetchReviews()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Reviews"
        // It seems UIRefreshControl is not optimised for large navBar titles
        // navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .blackOpaque
        navigationController?.navigationBar.barTintColor = .red
    }
    
    @objc private func refreshData() {
        currentPage = 0
        reviews = []
        tableView.reloadData()
        fetchReviews {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func fetchReviews(_ completion: (() -> ())? = nil) {
        guard !isFetchInProgress else {
            self.refreshControl.endRefreshing()
            return
        }
        
        isFetchInProgress = true
        
        networkManager.getReviews(page: currentPage) { response in
            switch response {
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    
                    self.total = response.metadata.reviewsCount
                    self.reviews.append(contentsOf: response.reviews)
                    
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.reviews)
                        self.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.onFetchCompleted(with: .none)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    print(error.localizedDescription)
                }
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
}

// MARK: TableView DataSource
extension ReviewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isLoadingCell(for: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(LoadingCell.self)", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReviewCell.self)", for: indexPath) as! ReviewCell
            let review = reviews[indexPath.row]
            
            let title = review.reviewer.firstName
            cell.avatarLabel.text = String(title.suffix(1).capitalized)
            cell.avatarLabel.backgroundColor = .red
            cell.titleLabel.text = title
            cell.subtitleLabel.text = review.localizedDate
            cell.textView.text = review.comments
            cell.highlightStars(index: review.rating)
    
            return cell
        }
        
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

// MARK: Fetch helpers
extension ReviewsViewController {
    
    fileprivate func fetchNextPage() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.fetchReviews()
        }
    }
    
    fileprivate func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    fileprivate func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= reviews.count
    }
    
    fileprivate func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    private func calculateIndexPathsToReload(from newReviews: [Review]) -> [IndexPath] {
        let startIndex = reviews.count - newReviews.count
        let endIndex = startIndex + newReviews.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

