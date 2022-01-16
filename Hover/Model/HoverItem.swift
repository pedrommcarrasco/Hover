//
//  HoverItem.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverItem
public struct HoverItem {
    
    // MARK: Properties
    let title: String?
    let image: UIImage?
    let tintColor: UIColor
    let backgroundColor: HoverColor
    let onTap: () -> ()
    
    // MARK: Lifecycle
    public init(
        title: String? = nil,
        image: UIImage?,
        tintColor: UIColor = .blue,
        backgroundColor: HoverColor = .color(.white),
        onTap: @escaping () -> ()
    ) {
        self.title = title
        self.image = image
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.onTap = onTap
    }
}
