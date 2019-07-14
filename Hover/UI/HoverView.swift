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
    private let anchorGuides: [UILayoutGuide]
    private let button: HoverButton
    private let itemViews: [HoverItemView]
    private let itemsStackView: UIStackView = .create {
        $0.spacing = 8
    }
    private let dimView: UIView = .create {
        $0.alpha = 0.0
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // MARK: Private Properties
    private let buttonSize: CGFloat
    private let anchors: [HoverPosition]
    private let items: [HoverItem]
    private let spacing: CGFloat
    private var isOpen = false
    private var currentAnchor: HoverPosition = .bottomRight
    
    private let panRecognizer = UIPanGestureRecognizer()
    private var offset = CGPoint.zero
    private var anchorCenters: [CGPoint] {
        return anchorGuides.map { $0.layoutFrame.center }
    }
    
    // MARK: Lifecycle
    public init(color: HoverColor,
                image: UIImage?,
                buttonSize: CGFloat = 44.0,
                items: [HoverItem] = [],
                anchors: [HoverPosition] = .all,
                spacing: CGFloat = 12.0) {
        
        self.button = HoverButton(with: color, image: image)
        self.itemViews = items.map(HoverItemView.init)
        self.buttonSize = buttonSize
        self.anchors = anchors
        self.items = items
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
        button.center = anchorCenters[HoverPosition.allCases.firstIndex(of: currentAnchor)!]
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
        add(layoutGuides: anchorGuides)
        add(views: dimView, button, itemsStackView)
        itemsStackView.add(arrangedViews: itemViews, hidden: true)
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
                
                itemsStackView.bottomAnchor.constraint(equalTo: anchorGuides.last!.topAnchor, constant: -16),
                itemsStackView.trailingAnchor.constraint(equalTo: anchorGuides.last!.trailingAnchor),
                
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
            let projectedPosition = Calculator.project(velocity: velocity, decelerationRate: .normal, into: button.center)
            let nearestAnchorPosition = Calculator.nearestPoint(from: projectedPosition, to: anchorCenters)
            let relativeVelocity = Calculator.relativeVelocity(for: velocity, from: button.center, to: nearestAnchorPosition)
            
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
        UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8) {
            self.dimView.alpha = 1.0
            self.itemsStackView.arrangedSubviews.forEach {
                $0.isHidden = false
                $0.alpha = 1.0
            }
        }.startAnimation()
    }
    
    func animateClosingState() {
        UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8) {
            self.dimView.alpha = 0.0
            self.itemsStackView.arrangedSubviews.forEach {
                $0.isHidden = true
                $0.alpha = 0.0
            }
        }.startAnimation()
    }
}
