//
//  ReviewTableViewCell.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 01.06.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var starsStackView: UIStackView!
    
    var starImageViews: [UIImageView] {
        get {
            return starsStackView!.subviews as! [UIImageView]
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textContainerInset = .zero
            textView.isScrollEnabled = false
            
            let bezierPath = UIBezierPath(rect: CGRect(x: 8, y: 0, width: avatarLabel.frame.size.width, height: 8))
            textView.textContainer.exclusionPaths = [bezierPath]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarLabel.layer.masksToBounds = true
        avatarLabel.layer.cornerRadius = avatarLabel.bounds.size.width / 2
    }
    
    func highlightStars(index: Int) {
        guard index > 0 && index <= 5 else {
            return
        }
        
        for i in 0..<index {
            starImageViews[i].isHighlighted = true
        }
    }
}
