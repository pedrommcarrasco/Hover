//
//  UIStackView+Add.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - Add
extension UIStackView {
    
    func add(arrangedViews: UIView..., hidden: Bool = false) {
        add(arrangedViews: arrangedViews, hidden: hidden)
    }
    
    func add(arrangedViews: [UIView], hidden: Bool = false) {
        arrangedViews.forEach {
            self.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.alpha = hidden ? 0.0 : 1.0
        }
    }
    func removeAll() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
