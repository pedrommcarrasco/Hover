//
//  CALayer+Decorators.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - Corners
extension CALayer {

    func decorateAsCircle() {
        cornerRadius = bounds.height / 2
    }
}
