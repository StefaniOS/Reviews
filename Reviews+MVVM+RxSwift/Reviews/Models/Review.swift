//
//  Review.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import Foundation

struct Review: Decodable {
    let id: Int
    let comments: String
    let reviewer: Reviewer
    let localizedDate: String
    let rating: Int
}

struct Reviewer: Decodable {
    let id: Int
    let firstName: String
    let pictureUrl: String
}

struct Metadata: Decodable {
    let reviewsCount: Int
}

struct Response: Decodable {
    let reviews: [Review]
    let metadata: Metadata
}
