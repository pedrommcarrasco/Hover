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
        static let animationDuration = 0.5
        static let animationDamping: CGFloat = 0.4
        static let highlightColor = UIColor.white.withAlphaComponent(0.2)
    }
    
    // MARK: Outlets
    private var gradientLayer: CAGradientLayer?
    private let imageView: UIImageView = .create {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }
    private let hightlightView: UIView = .create {
        $0.backgroundColor = Constant.highlightColor
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
        $0.alpha = 0.0
    }
    
    // MARK: Overriden Properties
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }
    
    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? Constant.scaleDownTransform : .identity
            let alpha: CGFloat = isHighlighted ? 1.0 : 0.0
            
            UIViewPropertyAnimator(duration: Constant.animationDuration, dampingRatio: Constant.animationDamping) {
                self.transform = transform
                self.hightlightView.alpha = alpha
            }.startAnimation()
        }
    }
    
    // MARK: Lifecycle
    init(with color: HoverColor, image: UIImage?, imageSizeRatio: CGFloat) {
        super.init(frame: .zero)
        configure(with: color, image: image, imageSizeRatio: imageSizeRatio)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
        layer.decorateAsCircle()
        hightlightView.layer.decorateAsCircle()
        gradientLayer?.frame = bounds
        gradientLayer?.decorateAsCircle()
        addShadow()
    }
}

// MARK: - Configuration
private extension HoverButton {
    
    func configure(with color: HoverColor, image: UIImage?, imageSizeRatio: CGFloat) {
        addSubviews()
        defineConstraints(with: imageSizeRatio)
        setupSubviews(with: color, image: image)
    }
    
    func addSubviews() {
        add(views: imageView, hightlightView)
    }
    
    func defineConstraints(with imageSizeRatio: CGFloat) {
        NSLayoutConstraint.activate(
            [
                imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: imageSizeRatio),
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
    
    func setupSubviews(with color: HoverColor, image: UIImage?) {
        imageView.image = image
        
        switch color {
        case .color(let color):
            backgroundColor = color
        case .gradient(let top, let bottom):
            gradientLayer = makeGradientLayer()
            gradientLayer?.colors = [bottom, top].map { $0.cgColor }
        }
    }
}
