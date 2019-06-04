//
//  ReviewCell.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    fileprivate enum Constants {
        static let padding: CGFloat = 16
        static let avatarRadius: CGFloat = 32
        static let cornerRadius: CGFloat = 16
    }
    
    fileprivate let avatarLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    fileprivate let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    fileprivate let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainer.maximumNumberOfLines = 20
        textView.textContainer.lineBreakMode = .byTruncatingTail
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupLayout()
    }

    func setupSubviews() {
        contentView.addSubview(avatarLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(textView)
    }
    
    func configure(with viewModel: ReviewViewModel?) {
        if let viewModel = viewModel {
            avatarLabel.text = String(viewModel.title.suffix(1).capitalized) // TODO:
            avatarLabel.backgroundColor = UIColor.Custom.red
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.date
            textView.text = viewModel.message
        }
    }
    
    func setupLayout() {
        
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding:CGFloat = Constants.padding
        let avatarRadius:CGFloat = Constants.avatarRadius
        
        let layoutGuide = contentView.layoutMarginsGuide
        
        avatarLabel.layer.cornerRadius = avatarRadius
        avatarLabel.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            avatarLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: padding / 2),
            avatarLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: padding / 2),
            avatarLabel.heightAnchor.constraint(equalToConstant: avatarRadius * 2.0),
            avatarLabel.widthAnchor.constraint(equalToConstant: avatarRadius * 2.0)
            ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: avatarLabel.topAnchor, constant: padding / 2),
            titleLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 2 * padding)
            ])

        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding/2),
            subtitleLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: padding)
            ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: avatarLabel.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
        
        // Cell content apperearance
        let greenColor = UIColor.Custom.green
        contentView.backgroundColor = greenColor
        layer.cornerRadius = Constants.cornerRadius
        layer.borderColor = greenColor.cgColor
        layer.masksToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReviewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
