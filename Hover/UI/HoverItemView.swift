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
    
    // MARK: Outlets
    private let button: HoverButton
    private let label: UILabel = .create {
        $0.textColor = .white
    }
    
    // MARK: Properties
    var onTap: (() -> ())?
    var orientation: Orientation {
        didSet { adapt(to: orientation) }
    }
    
    // MARK: Private Properties
    private let item: HoverItem
    private let size: CGFloat
    
    // MARK: Lifecycle
    init(with item: HoverItem, orientation: Orientation, size: CGFloat) {
        self.item = item
        self.orientation = orientation
        self.size = size
        self.button = HoverButton(with: .color(.white), image: item.image)
        self.label.text = item.title
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
private extension HoverItemView {
    
    func configure() {
        axis = .horizontal
        spacing = 8
        
        addSubviews()
        setupSubviews()
    }
    
    func addSubviews() {
        adapt(to: orientation)
        
        NSLayoutConstraint.activate(
            [
                button.heightAnchor.constraint(equalToConstant: size),
                button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ]
        )
    }
    
    func setupSubviews() {
        button.addTarget(self, action: #selector(onTapInButton), for: .touchUpInside)
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
    
    func adapt(to orientation: Orientation) {
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
