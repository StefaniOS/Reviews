//
//  ReviewViewModel.swift
//  
//
//  Created by Stepan Vardanyan on 03.06.19.
//

import XCTest
@testable import Reviews

class ReviewViewModelTests: XCTestCase {
    
    var review: Review!
    var reviewViewModel: ReviewViewModel!
    
    override func setUp() {
        let reviewer = Reviewer(id: 0, firstName: "Reviewer", pictureUrl: "pictureUrl")
        review = Review(id: 0, comments: "message", reviewer: reviewer, localizedDate: "June 2019", rating: 5)
        reviewViewModel = ReviewViewModel(review: review)
    }
    
    func testRevieViewModel() {
        XCTAssertEqual(review.comments, reviewViewModel.message)
        XCTAssertEqual(review.reviewer.firstName, reviewViewModel.title)
        XCTAssertEqual(review.localizedDate, reviewViewModel.date)
        XCTAssertEqual(review.rating, reviewViewModel.rating)
        
        XCTAssertEqual(reviewViewModel.title, "Reviewer")
        XCTAssertEqual(reviewViewModel.message, "message")
        XCTAssertEqual(reviewViewModel.rating, 5)
        
        XCTAssertNotEqual(reviewViewModel.title, "reviewer")
        XCTAssertNotEqual(reviewViewModel.message, "comment")
        XCTAssertNotEqual(reviewViewModel.rating, 0)
    }
}
