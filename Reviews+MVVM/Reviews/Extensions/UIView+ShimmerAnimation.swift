//
//  UIView+ShimmerAnimation.swift
//  Reviews
//
//  Created by Stepan Vardanyan on 26.05.19.
//  Copyright © 2019 Stepan Vardanyan. All rights reserved.
//

import UIKit

extension UIView {
    func startShimmerAnimation(for subviews:[UIView]) {
        for animateView in subviews {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.5
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            
            gradientLayer.add(animation, forKey: "")
        }
    }
    
    func stopShimmerAnimation(for subviews:[UIView]) {
        for animateView in subviews {
            animateView.layer.removeAllAnimations()
            animateView.layer.mask = nil
        }
    }
}
