//
//  ReviewsViewController.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewsViewController: UIViewController {
    
    fileprivate enum Constants {
        static let cellIdentifier = "ReviewCell"
        static let padding: CGFloat = 16
    }
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: ReviewsViewModel!
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInsetReference = .fromLayoutMargins
        layout.sectionInset = .zero
        return layout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.backgroundColor = .white
        let padding = Constants.padding
        collectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return collectionView
    }()
    
    init(_ factory: Factory) {
        self.viewModel = factory.reviewsViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupBindings()
    }
    
    func fetchReviews() {
        viewModel.fetchReviews()
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupBindings() {
        collectionView.dataSource = nil
        collectionView.delegate = nil
        
        viewModel.reviews
            .bind(to: collectionView.rx.items(cellIdentifier: Constants.cellIdentifier)) { (index, review , cell) in
                let cell = cell as! ReviewCell
                let viewModel = ReviewViewModel(review: review)
                cell.configure(with: viewModel)
            }.disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension ReviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 100
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.padding
    }
}
