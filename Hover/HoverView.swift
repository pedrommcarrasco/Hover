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
    private let button = UIButton()
    private let anchorGuides: [UILayoutGuide]
    
    // MARK: Private Properties
    private let buttonSize: CGFloat
    private let anchors: [HoverPosition]
    
    private let panRecognizer = UIPanGestureRecognizer()
    private var offset = CGPoint.zero
    private var anchorCenters: [CGPoint] {
        return anchorGuides.map { $0.layoutFrame.center }
    }
    
    // MARK: Lifecycle
    public init(buttonSize: CGFloat, anchors: [HoverPosition]) {
        self.buttonSize = buttonSize
        self.anchors = anchors
        self.anchorGuides = anchors.map { _ in return UILayoutGuide() }
        super.init(frame: .zero)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.bounds.height / 2
        button.clipsToBounds = true
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
        addSubview(button)
        anchorGuides.forEach { self.addLayoutGuide($0) }
    }
    
    func defineConstraints() {
        zip(self.anchors, self.anchorGuides).forEach {
            $0.configurePosition(of: $1, inside: self)
            NSLayoutConstraint.activate(
                [
                    $1.widthAnchor.constraint(equalToConstant: self.buttonSize),
                    $1.heightAnchor.constraint(equalToConstant: self.buttonSize)
                ]
            )
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                button.widthAnchor.constraint(equalToConstant: self.buttonSize),
                button.heightAnchor.constraint(equalToConstant: self.buttonSize)
            ]
        )
    }
    
    func setupSubviews() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(from:)))
        button.addGestureRecognizer(panRecognizer)
        button.backgroundColor = .red
    }
}

// MARK: - Gestures
private extension HoverView {
    
    @objc
    func onPan(from recognizer: UIPanGestureRecognizer) {
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
            
            let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeVelocity)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {  self.button.center = nearestAnchorPosition }
            animator.startAnimation()
        default:
            break
        }
    }
}
