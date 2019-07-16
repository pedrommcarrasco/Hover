//
//  Orientation.swift
//  Hover
//
//  Created by Pedro Carrasco on 14/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - XOrientation
enum XOrientation {
    case leftToRight
    case rightToLeft
    
    var translationModifier: CGFloat {
        switch self {
        case .leftToRight:
            return -1.0
        case .rightToLeft:
            return 1.0
        }
    }
}

// MARK: - YOrientation
enum YOrientation {
    case topToBottom
    case bottomToTop
    
    func reverseArrayIfNeeded<T>(_ array: [T]) -> [T] {
        switch self {
        case .topToBottom:
            return array
        case .bottomToTop:
            return array.reversed()
        }
    }
}
