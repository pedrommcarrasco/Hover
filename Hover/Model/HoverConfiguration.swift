//
//  HoverConfiguration.swift
//  Hover
//
//  Created by Pedro Carrasco on 14/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverConfiguration
public struct HoverConfiguration {
    
    // MARK: Properties
    public var color: HoverColor
    public var icon: UIImage?
    public var size: CGFloat
    public var spacing: CGFloat
    public var initialPosition: HoverPosition
    public var allowedPositions: [HoverPosition]
    
    
    private var itemSizeRatio: CGFloat = 0.75
    
    var itemSize: CGFloat {
        return size * itemSizeRatio
    }
    
    var itemMargin: CGFloat {
        return size * ((1.0 - itemSizeRatio) / 2.0)
    }
    
    
    // MARK: Init
    public init(icon: UIImage? = nil,
                color: HoverColor = .color(.white),
                size: CGFloat = 60.0,
                spacing: CGFloat = 12.0,
                initialPosition: HoverPosition,
                allowedPositions: [HoverPosition] = .all) {
        
        self.icon = icon
        self.color = color
        self.size = size
        self.spacing = spacing
        self.initialPosition = initialPosition
        self.allowedPositions = allowedPositions
    }
}

