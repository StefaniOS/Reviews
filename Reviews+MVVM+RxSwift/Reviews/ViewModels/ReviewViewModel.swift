//
//  ReviewViewModel.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation

struct ReviewViewModel {
    let title: String
    let message: String
    let date: String
    let rating: Int
    
    init(review: Review) {
        self.title = review.reviewer.firstName
        self.message = review.comments
        self.date = review.localizedDate
        self.rating = review.rating
    }
}
