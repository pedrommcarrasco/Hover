//
//  Anchor.swift
//  Hover
//
//  Created by Pedro Carrasco on 14/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - Anchor
struct Anchor {
    
    // MARK: Properties
    let position: HoverPosition
    let guide = UILayoutGuide()
    
    var center: CGPoint {
        return guide.layoutFrame.center
    }
}

// MARK: - Equatable
extension Anchor: Equatable {}
