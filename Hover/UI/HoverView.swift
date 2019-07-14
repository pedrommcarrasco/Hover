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
    
    enum State {
        case none
        case animating
        case pending
    }
    
    // MARK: Outlets
    private let button: HoverButton
    private let itemViews: [HoverItemView]
    private let itemsStackView: UIStackView = .create {
        $0.spacing = 12
        $0.axis = .vertical
    }
    private let dimView: UIView = .create {
        $0.alpha = 0.0
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // MARK: Constraints
    private var stackViewXConstraint = NSLayoutConstraint()
    private var stackViewYConstraint = NSLayoutConstraint()
    
    
    // MARK: Private Properties
    private let anchors: [Anchor]
    private var currentAnchor: Anchor {
        didSet {
            if state == .animating {
                state = .pending
            } else {
                adapt(to: currentAnchor)
            }
        }
    }
    
    private let configuration: HoverConfiguration
    private let items: [HoverItem]
    private var isOpen = false
    private var state: State = .none
    
    private let panRecognizer = UIPanGestureRecognizer()
    private var offset = CGPoint.zero
    
    
    // MARK: Lifecycle
    public init(with configuration: HoverConfiguration,
                items: [HoverItem] = []) {
        
        guard !configuration.allowedPositions.isEmpty else {
            fatalError("`allowedPositions` can't be empty")
        }
        
        self.anchors = configuration.allowedPositions.map(Anchor.init)
        
        guard let currentAnchor = anchors.first(where: { $0.position == configuration.initialPosition }) else {
            fatalError("`allowedPositions` must contain the `initalPosition`")
        }
        
        self.currentAnchor = currentAnchor
        self.configuration = configuration
        self.button = HoverButton(with: configuration.color, image: configuration.icon)
        self.itemViews = items.map { HoverItemView(with: $0, orientation: currentAnchor.position.orientation, size: configuration.itemSize) }
        self.items = items
        super.init(frame: .zero)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        button.center = currentAnchor.center
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
        add(layoutGuides: anchors.map { $0.guide })
        add(views: dimView, itemsStackView, button)
        itemsStackView.add(arrangedViews: itemViews, hidden: true)
    }
    
    func defineConstraints() {
        anchors.forEach {
            $0.position.configurePosition(of: $0.guide, inside: self, with: self.configuration.spacing)
            NSLayoutConstraint.activate(
                [
                    $0.guide.widthAnchor.constraint(equalToConstant: self.configuration.size),
                    $0.guide.heightAnchor.constraint(equalToConstant: self.configuration.size)
                ]
            )
        }
        
        NSLayoutConstraint.activate(
            [
                button.widthAnchor.constraint(equalToConstant: configuration.size),
                button.heightAnchor.constraint(equalToConstant: configuration.size),
                
                dimView.topAnchor.constraint(equalTo: topAnchor),
                dimView.bottomAnchor.constraint(equalTo: bottomAnchor),
                dimView.leadingAnchor.constraint(equalTo: leadingAnchor),
                dimView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
    
    func setupSubviews() {
        adapt(to: currentAnchor)
        
        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapInDim)))
        
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(from:))))
        button.addTarget(self, action: #selector(onTapInButton), for: .touchUpInside)
        
        itemViews.forEach { $0.onTap = onTapInButton }
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
            currentAnchor = Calculator.nearestPoint(from: projectedPosition, to: anchors)
            let relativeVelocity = Calculator.relativeVelocity(for: velocity, from: button.center, to: currentAnchor.center)
            
            let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.5, initialVelocity: relativeVelocity)
            let animator = UIViewPropertyAnimator(duration: 0.15, timingParameters: timingParameters)
            animator.addAnimations {  self.button.center = self.currentAnchor.center }
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
        UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.dimView.alpha = 1.0
        }.startAnimation()
        
        UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8) {
            self.itemsStackView.arrangedSubviews.forEach {
                $0.isHidden = false
                $0.alpha = 1.0
            }
        }.startAnimation()
    }
    
    func animateClosingState() {
        self.state = .animating
        
        UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.dimView.alpha = 0.0
        }.startAnimation()
        
        let animator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8) {
            self.dimView.alpha = 0.0
            self.itemsStackView.arrangedSubviews.forEach {
                $0.isHidden = true
                $0.alpha = 0.0
            }
        }
        
        animator.addCompletion { _ in
            if self.state == .pending {
                self.adapt(to: self.currentAnchor)
            }
            
            self.state = .none
        }
        
        animator.startAnimation()
    }
}

// MARK: - Condional Constraints
private extension HoverView {
    
    func adapt(to anchor: Anchor) {
        setConstraints(for: currentAnchor)
        itemViews.forEach { $0.orientation = currentAnchor.position.orientation }
    }
    
    func setConstraints(for anchor: Anchor) {
        NSLayoutConstraint.deactivate([stackViewXConstraint, stackViewYConstraint])
        switch anchor.position {
        case .topLeft:
            stackViewXConstraint = itemsStackView.leadingAnchor.constraint(equalTo: anchor.guide.leadingAnchor, constant: self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.topAnchor.constraint(equalTo: currentAnchor.guide.bottomAnchor, constant: self.configuration.spacing)
        case .topRight:
            stackViewXConstraint = itemsStackView.trailingAnchor.constraint(equalTo: anchor.guide.trailingAnchor, constant: -self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.topAnchor.constraint(equalTo: currentAnchor.guide.bottomAnchor, constant: self.configuration.spacing)
        case .bottomLeft:
            stackViewXConstraint = itemsStackView.leadingAnchor.constraint(equalTo: anchor.guide.leadingAnchor, constant: self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.bottomAnchor.constraint(equalTo: currentAnchor.guide.topAnchor, constant: -self.configuration.spacing)
        case .bottomRight:
            stackViewXConstraint = itemsStackView.trailingAnchor.constraint(equalTo: anchor.guide.trailingAnchor, constant: -self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.bottomAnchor.constraint(equalTo: currentAnchor.guide.topAnchor, constant: -self.configuration.spacing)
        }
        NSLayoutConstraint.activate([stackViewXConstraint, stackViewYConstraint])
    }
}
