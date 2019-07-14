//
//  UIView+Add.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - Add
extension UIView {
    
    func add(views: UIView...) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func add(views: [UIView]) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func add(layoutGuides: [UILayoutGuide]) {
        layoutGuides.forEach {
            self.addLayoutGuide($0)
        }
    }
}
