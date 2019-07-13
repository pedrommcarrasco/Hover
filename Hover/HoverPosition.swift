//
//  HoverPosition.swift
//  Hover
//
//  Created by Pedro Carrasco on 12/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverPosition
public enum HoverPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

// MARK: - Configuration
extension HoverPosition {

    func configurePosition(of guide: UILayoutGuide, inside view: UIView) {
        let positionConstraints: [NSLayoutConstraint]
        switch self {
        case .topLeft:
            positionConstraints = [
                guide.topAnchor.constraint(equalTo: view.topAnchor),
                guide.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            ]
        case .topRight:
            positionConstraints = [
                guide.topAnchor.constraint(equalTo: view.topAnchor),
                guide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        case .bottomLeft:
            positionConstraints = [
                guide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                guide.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            ]
        case .bottomRight:
            positionConstraints = [
                guide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                guide.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        }
        NSLayoutConstraint.activate(positionConstraints)
    }
}

// MARK: - Sugar
public extension Array where Element == HoverPosition {

    static let all: [HoverPosition] = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}
