//
//  ReviewsViewModel.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation
import RxSwift

final class ReviewsViewModel {
    
    // Services
    private let networkManager: NetworkManager!
    
    // Reactive
    let reviews = BehaviorSubject<[Review]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(_ factory: Factory) {
        self.networkManager = factory.networkManager
    }
    
    func fetchReviews() {
        networkManager
            .getReviews()
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: reviews)
            .disposed(by: disposeBag)
    }
}
