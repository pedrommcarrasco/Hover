//
//  HoverItemView.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverItemView
class HoverItemView: UIStackView {
    
    // MARK: Constant
    private enum Constant {
        static let interItemSpacing: CGFloat = 8.0
    }
    
    // MARK: Outlets
    private let button: HoverButton
    private let label: UILabel = .create {
        $0.textColor = .white
    }
    
    // MARK: Properties
    var onTap: (() -> ())?
    var orientation: Orientation.X {
        didSet { adapt(to: orientation) }
    }
    
    // MARK: Private Properties
    private let item: HoverItem
    
    // MARK: Lifecycle
    init(with item: HoverItem, configuration: HoverItemConfiguration) {
        self.item = item
        self.orientation = configuration.initialXOrientation
        self.button = HoverButton(with: item.color, image: item.image, imageSizeRatio: configuration.imageSizeRatio)
        
        if let font = configuration.font {
            self.label.font = font
        }
        
        self.label.text = item.title

        super.init(frame: .zero)
        configure(with: configuration)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
private extension HoverItemView {
    
    func configure(with configuration: HoverItemConfiguration) {
        spacing = Constant.interItemSpacing
        
        addSubviews()
        defineConstraints(with: configuration.size)
        setupSubviews()
    }
    
    func addSubviews() {
        adapt(to: orientation)
    }
    
    func defineConstraints(with size: CGFloat) {
        NSLayoutConstraint.activate(
            [
                button.heightAnchor.constraint(equalToConstant: size),
                button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ]
        )
    }
    
    func setupSubviews() {
        button.addTarget(self, action: #selector(onTapInButton), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapInButton))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }
}

// MARK: - Actions
private extension HoverItemView {
    
    @objc
    func onTapInButton() {
        item.onTap()
        onTap?()
    }
}

// MARK: - Condional Constraints
private extension HoverItemView {
    
    func adapt(to orientation: Orientation.X) {
        switch orientation {
        case .leftToRight:
            label.textAlignment = .left
            add(arrangedViews: button, label)
        case .rightToLeft:
            label.textAlignment = .right
            add(arrangedViews: label, button)
        }
    }
}
