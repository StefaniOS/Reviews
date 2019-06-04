//
//  ReviewsViewModel.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation

protocol ReviewsViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class ReviewsViewModel {
    
    private weak var delegate: ReviewsViewModelDelegate?
    
    private var viewModels: [ReviewViewModel] = []
    private var currentPage = 0
    private var isFetchInProgress = false
    
    private(set) var total = 0
    
    private let networkManager: NetworkManager!
    
    var currentCount: Int {
        return viewModels.count
    }
    
    func reviewViewModel(at index: Int) -> ReviewViewModel {
        return viewModels[index]
    }
    
    init(networkManager: NetworkManager, delegate: ReviewsViewModelDelegate) {
        self.networkManager = networkManager
        self.delegate = delegate
    }
    
    func fetchReviews() {
        guard !isFetchInProgress else {
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
                    let viewModels = response.reviews.map({ReviewViewModel(review: $0)})
                    self.viewModels.append(contentsOf: viewModels)

                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: viewModels)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newViewModels: [ReviewViewModel]) -> [IndexPath] {
        let startIndex = viewModels.count - newViewModels.count
        let endIndex = startIndex + newViewModels.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
