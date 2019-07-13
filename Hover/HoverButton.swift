//
//  HoverButton.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: HoverButton
class HoverButton: UIControl {
    
    // MARK: Constant
    private enum Constant {
        static let minimumHeight: CGFloat = 44.0
        static let scaleDownTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    // MARK: Outlets
    private lazy var gradientLayer = decorateWithGradient()
    private let imageView: UIImageView = .create {
        $0.contentMode = .scaleAspectFit
    }
    private let hightlightView: UIView = .create {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
        $0.alpha = 0.0
    }
    
    // MARK: Overriden Properties
    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? Constant.scaleDownTransform : .identity
            let alpha: CGFloat = isHighlighted ? 1.0 : 0.0
            
            UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.4) {
                self.transform = transform
                self.hightlightView.alpha = alpha
            }.startAnimation()
        }
    }
    
    // MARK: Lifecycle
    init(with colors: [UIColor], image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        gradientLayer.colors = colors.map{ $0.cgColor }
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.decorateAsCircle()
        hightlightView.layer.decorateAsCircle()
        gradientLayer.frame = bounds
        gradientLayer.decorateAsCircle()
        decorateWithShadow()
    }
}

// MARK: - Configuration
private extension HoverButton {
    
    func configure() {
        addSubviews()
        defineConstraints()
    }
    
    func addSubviews() {
        add(views: imageView, hightlightView)
    }
    
    func defineConstraints() {
        NSLayoutConstraint.activate(
            [
                imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                hightlightView.topAnchor.constraint(equalTo: topAnchor),
                hightlightView.bottomAnchor.constraint(equalTo: bottomAnchor),
                hightlightView.leadingAnchor.constraint(equalTo: leadingAnchor),
                hightlightView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
}
