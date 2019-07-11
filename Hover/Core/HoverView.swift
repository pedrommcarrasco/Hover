//
//  HoverView.swift
//  Hover
//
//  Created by Pedro Carrasco on 11/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverView
class HoverView: UIView {
    
    // MARK: Outlets
    private let button = UIButton()
    private var positionViews = [UIView]() {
        didSet {
            positionViews.forEach { $0.isHidden = true }
        }
    }
    
    // MARK: Private Properties
    private let panRecognizer = UIPanGestureRecognizer()
    private var positionsCenters: [CGPoint] {
        return positionViews.map { $0.center }
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
}

enum HoverPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
