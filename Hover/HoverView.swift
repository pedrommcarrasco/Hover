//
//  HoverView.swift
//  Hover
//
//  Created by Pedro Carrasco on 11/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit



// MARK: - HoverView
public class HoverView: UIView {
    
    // MARK: Outlets
    private let dimView = UIView()
    private let button: HoverButton
    private let anchorGuides: [UILayoutGuide]
    
    // MARK: Private Properties
    private var isOpen: Bool = false
    private let buttonSize: CGFloat
    private let anchors: [HoverPosition]
    private let spacing: CGFloat
    
    private let panRecognizer = UIPanGestureRecognizer()
    private var offset = CGPoint.zero
    private var anchorCenters: [CGPoint] {
        return anchorGuides.map { $0.layoutFrame.center }
    }
    
    // MARK: Lifecycle
    public init(colors: [UIColor], image: UIImage?, buttonSize: CGFloat = 44.0, anchors: [HoverPosition] = .all, spacing: CGFloat = 12.0) {
        self.button = HoverButton(with: colors, image: image)
        self.buttonSize = buttonSize
        self.anchors = anchors
        self.spacing = spacing
        self.anchorGuides = anchors.map { _ in return UILayoutGuide() }
        super.init(frame: .zero)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        button.center = anchorCenters.last ?? .zero
    }
}

// MARK: - Configuration
private extension HoverView {
    
    func configure() {
        addSubviews()
        defineConstraints()
        setupSubviews()
    }
    
    func addSubviews() {
        add(views: dimView, button)
        add(layoutGuides: anchorGuides)
    }
    
    func defineConstraints() {
        zip(self.anchors, self.anchorGuides).forEach {
            $0.configurePosition(of: $1, inside: self, with: self.spacing)
            NSLayoutConstraint.activate(
                [
                    $1.widthAnchor.constraint(equalToConstant: self.buttonSize),
                    $1.heightAnchor.constraint(equalToConstant: self.buttonSize)
                ]
            )
        }
        
        NSLayoutConstraint.activate(
            [
                button.widthAnchor.constraint(equalToConstant: self.buttonSize),
                button.heightAnchor.constraint(equalToConstant: self.buttonSize),
                
                dimView.topAnchor.constraint(equalTo: topAnchor),
                dimView.bottomAnchor.constraint(equalTo: bottomAnchor),
                dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
                dimView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
    
    func setupSubviews() {
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(from:))))
        button.addTarget(self, action: #selector(onTapInButton), for: .touchUpInside)
        
        dimView.alpha = 0
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapInDim)))
    }
}

// MARK: - Gestures
private extension HoverView {
    
    @objc
    func onTapInButton() {
        animateState(to: !isOpen)
    }
    
    @objc
    func onTapInDim() {
        animateState(to: false)
    }
    
    @objc
    func onPan(from recognizer: UIPanGestureRecognizer) {
        animateState(to: false)
        
        let touchPoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began:
            offset = touchPoint - button.center
        case .changed:
            button.center =  touchPoint - offset
        case .ended, .cancelled:
            let velocity = recognizer.velocity(in: self)
            let projectedPosition = HoverPhysics.project(velocity: velocity, decelerationRate: .normal, into: button.center)
            let nearestAnchorPosition = HoverPhysics.nearestPoint(from: projectedPosition, to: anchorCenters)
            let relativeVelocity = HoverPhysics.relativeVelocity(for: velocity, from: button.center, to: nearestAnchorPosition)
            
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.5, initialVelocity: relativeVelocity)
            let animator = UIViewPropertyAnimator(duration: 0.15, timingParameters: timingParameters)
            animator.addAnimations {  self.button.center = nearestAnchorPosition }
            animator.startAnimation()
        default:
            break
        }
    }
}

// MARK: - Animations
private extension HoverView {
    
    func animateState(to isOpen: Bool) {
        guard self.isOpen != isOpen else { return }
        self.isOpen = isOpen
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if isOpen {
            animateOpeningState()
        } else {
            animateClosingState()
        }
    }
    
    func animateOpeningState() {
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 1.0
        }
    }
    
    func animateClosingState() {
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.0
        }
    }
}
