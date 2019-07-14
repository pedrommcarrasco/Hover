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
    private let label = UILabel()
    
    // MARK: Properties
    var onTap: (() -> ())?
    
    // MARK: Private Properties
    private let item: HoverItem
    
    // MARK: Lifecycle
    init(with item: HoverItem) {
        self.item = item
        self.label.text = item.title
        self.button = HoverButton(with: .color(.white), image: item.image)
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
        add(arrangedViews: label, button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupSubviews() {
        label.textColor = .white
        button.addTarget(self, action: #selector(onTapInButton), for: .touchUpInside)
    }
}


private extension HoverItemView {
    
    @objc
    func onTapInButton() {
        item.onTap()
        onTap?()
    }
}
