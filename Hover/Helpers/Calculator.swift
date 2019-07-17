//
//  Calculator.swift
//  Hover
//
//  Created by Pedro Carrasco on 12/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - Calculator
struct Calculator {
    
    // MARK: Constant
    private enum Constant {
        static let delayMultiplier = 0.05
        static let translationBase: CGFloat = 50.0
        static let translationMultiplier: CGFloat = 10.0
    }
    
    // MARK: Functions
    static func nearestPoint(from point: CGPoint, to points: [Anchor]) -> Anchor {
        var minimumDistance = CGFloat.greatestFiniteMagnitude
        return points.reduce(into: points[0]) {
            let distance = point.distance(to: $1.center)
            if distance < minimumDistance {
                minimumDistance = distance
                $0 = $1
            }
        }
    }

    static func relativeVelocity(for velocity: CGPoint, from pointA: CGPoint, to pointB: CGPoint) -> CGVector {
        return CGVector(dx: relativeVelocity(for: velocity.x, from: pointA.x, to: pointB.x),
                        dy: relativeVelocity(for: velocity.y, from: pointA.y, to: pointB.y))
    }
    
    static func project(velocity: CGPoint, decelerationRate: UIScrollView.DecelerationRate, into point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x + project(velocity: velocity.x, decelerationRate: .normal),
                       y: point.y + project(velocity: velocity.y, decelerationRate: .normal))
    }
    
    static func delay(for index: Int) -> TimeInterval {
        return Constant.delayMultiplier * Double(index)
    }
    
    static func translation(for index: Int, anchor: Anchor) -> CGAffineTransform {
        let extra = Constant.translationMultiplier * CGFloat(index)
        return CGAffineTransform(translationX: (Constant.translationBase + extra) * anchor.position.xOrientation.translationModifier,
                                 y: .zero)
    }
}

// MARK: - Private Functions
private extension Calculator {
    
    static func project(velocity: CGFloat, decelerationRate: UIScrollView.DecelerationRate) -> CGFloat {
        return (velocity / 2500) * decelerationRate.rawValue / (1 - decelerationRate.rawValue)
    }
    
    static func relativeVelocity(for velocity: CGFloat, from valueA: CGFloat, to valueB: CGFloat) -> CGFloat {
        guard valueA - valueB != .zero else { return .zero }
        return velocity / (valueB - valueA)
    }
}
