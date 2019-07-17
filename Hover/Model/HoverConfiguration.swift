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
    
    // MARK: Constant
    private enum Constant {
        static let itemSizeRatio: CGFloat = 0.75
        static let defaultSize: CGFloat = 60.0
    }
    
    // MARK: Properties
    public var color: HoverColor
    public var icon: UIImage?
    public var size: CGFloat
    public var spacing: CGFloat
    public var font: UIFont?
    public var initialPosition: HoverPosition
    public var allowedPositions: [HoverPosition]
    
    var itemConfiguration: HoverItemConfiguration {
        return HoverItemConfiguration(size: size * Constant.itemSizeRatio,
                                      margin: size * ((1 - Constant.itemSizeRatio) / 2),
                                      font: font,
                                      initialXOrientation: initialPosition.xOrientation)
    }
    
    // MARK: Init
    public init(icon: UIImage? = nil,
                color: HoverColor = .color(.blue),
                size: CGFloat = 60.0,
                spacing: CGFloat = 12.0,
                initialPosition: HoverPosition = .bottomRight,
                allowedPositions: [HoverPosition] = .all,
                font: UIFont? = nil) {
        
        self.icon = icon
        self.color = color
        self.size = size
        self.spacing = spacing
        self.font = font
        self.initialPosition = initialPosition
        self.allowedPositions = allowedPositions
    }
}

// MARK: - HoverItemConfiguration
struct HoverItemConfiguration {
    
    let size: CGFloat
    let margin: CGFloat
    let font: UIFont?
    let initialXOrientation: Orientation.X
}

