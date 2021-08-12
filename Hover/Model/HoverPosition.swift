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

// MARK: - Properties
extension HoverPosition {
    
    var xOrientation: Orientation.X {
        switch self {
        case .topLeft, .bottomLeft:
            return .leftToRight
        case .topRight, .bottomRight:
            return .rightToLeft
        }
    }
    
    var yOrientation: Orientation.Y {
        switch self {
        case .bottomLeft, .bottomRight:
            return .bottomToTop
        case .topLeft, .topRight:
            return .topToBottom
        }
    }
}

// MARK: - Configuration
extension HoverPosition {

    func configurePosition(of guide: UILayoutGuide, inside view: UIView, with insets: UIEdgeInsets) {
        let positionConstraints: [NSLayoutConstraint]
        switch self {
        case .topLeft:
            positionConstraints = [
                guide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                guide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: insets.left)
            ]
        case .topRight:
            positionConstraints = [
                guide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top),
                guide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right)
            ]
        case .bottomLeft:
            positionConstraints = [
                guide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
                guide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: insets.left)
            ]
        case .bottomRight:
            positionConstraints = [
                guide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
                guide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right)
            ]
        }
        NSLayoutConstraint.activate(positionConstraints)
    }
}

// MARK: - Sugar
public extension Set where Element == HoverPosition {

    static let all: Set<HoverPosition> = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

// MARK: - CaseIterable
extension HoverPosition: CaseIterable {}

// MARK: - Equatable
extension HoverPosition: Equatable {}
