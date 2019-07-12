//
//  HoverPosition.swift
//  Hover
//
//  Created by Pedro Carrasco on 12/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverPosition
enum HoverPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

// MARK: - Configuration
extension HoverPosition {

    func configurePosition(of view: UIView, inside parentView: UIView) {
        let positionConstraints: [NSLayoutConstraint]
        switch self {
        case .topLeft:
            positionConstraints = [
                view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                view.topAnchor.constraint(equalTo: parentView.topAnchor)
            ]
        case .topRight:
            positionConstraints = [
                view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                view.topAnchor.constraint(equalTo: parentView.topAnchor)
            ]
        case .bottomLeft:
            positionConstraints = [
                view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ]
        case .bottomRight:
            positionConstraints = [
                view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ]
        }
        NSLayoutConstraint.activate(positionConstraints)
    }
}

// MARK: - Sugar
extension Array where Element == HoverPosition {

    static let all: [HoverPosition] = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}
