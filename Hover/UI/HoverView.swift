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

    // MARK: Constant
    private enum Constant {
        static let delayMultiplier = 0.05
        static let translationBase: CGFloat = 50.0
        static let translationMultiplier: CGFloat = 10.0
        static let animationDamping: CGFloat = 0.8
        static let animationResponse: CGFloat = 0.5
        static let animationDuration = 0.4
        static let anchorAnimationDuration = 0.15
        static let interItemSpacing: CGFloat = 12.0
        static let dimColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // MARK: State
    private enum State {
        case none
        case disappearing
        case pending
    }
    
    // MARK: Outlets
    private let button: HoverButton
    private let itemViews: [HoverItemView]
    private let itemsStackView: UIStackView = .create {
        $0.spacing = Constant.interItemSpacing
        $0.axis = .vertical
    }
    private let dimView: UIView = .create {
        $0.alpha = 0.0
        $0.backgroundColor = Constant.dimColor
    }
    
    // MARK: Constraints
    private var stackViewXConstraint = NSLayoutConstraint()
    private var stackViewYConstraint = NSLayoutConstraint()
    
    // MARK: Private Properties
    private let anchors: [Anchor]
    private var currentAnchor: Anchor {
        didSet {
            if state == .disappearing {
                state = .pending
            } else {
                adapt(to: currentAnchor)
            }
        }
    }
    
    private let configuration: HoverConfiguration
    private let items: [HoverItem]
    private var state: State = .none
    private var isOpen = false
    
    private let panRecognizer = UIPanGestureRecognizer()
    private var offset = CGPoint.zero
    
    
    // MARK: Lifecycle
    public init(with configuration: HoverConfiguration = .init(), items: [HoverItem] = .init()) {
        
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
        self.itemViews = items.reversed().map {
            HoverItemView(with: $0, orientation: currentAnchor.position.xOrientation, size: configuration.itemSize)
        }
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
            
            let timingParameters = UISpringTimingParameters(damping: Constant.animationDamping,
                                                            response: Constant.animationResponse,
                                                            initialVelocity: relativeVelocity)
            let animator = UIViewPropertyAnimator(duration: Constant.anchorAnimationDuration, timingParameters: timingParameters)
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
            animate(isOpening: true, anchor: currentAnchor)
        } else {
            state = .disappearing
            animate(isOpening: false, anchor: currentAnchor) {
                if self.state == .pending {
                    self.adapt(to: self.currentAnchor)
                }
                
                self.state = .none
            }
        }
    }
    
    private func animate(isOpening: Bool, anchor: Anchor, completion: (() -> Void)? = nil) {
        UIViewPropertyAnimator(duration: Constant.animationDuration, curve: .easeInOut) {
            self.dimView.alpha = isOpening ? 1.0 : 0.0
        }.startAnimation()
        
        anchor.position.yOrientation.reverseArrayIfNeeded(itemsStackView.arrangedSubviews).enumerated().forEach { (index, view) in
            let translationTransform = self.translation(for: index, anchor: anchor)
            view.transform = isOpening ? translationTransform : .identity
            
            let animator = UIViewPropertyAnimator(duration: Constant.animationDuration, dampingRatio: Constant.animationDamping) {
                view.transform = isOpening ? .identity : translationTransform
                view.alpha = isOpening ? 1.0 : 0.0
            }
            
            animator.addCompletion { _ in
                if index == self.itemsStackView.arrangedSubviews.count - 1 {
                    completion?()
                }
            }
            
            animator.startAnimation(afterDelay: self.delay(for: index))
        }
    }
    
    func delay(for index: Int) -> TimeInterval {
        return Constant.delayMultiplier * Double(index)
    }
    
    func translation(for index: Int, anchor: Anchor) -> CGAffineTransform {
        let extra = Constant.translationMultiplier * CGFloat(index)
        return CGAffineTransform(translationX: (Constant.translationBase + extra) * anchor.position.xOrientation.translationModifier,
                                 y: .zero)
    }
}

// MARK: - Condional Constraints
private extension HoverView {
    
    func adapt(to anchor: Anchor) {
        NSLayoutConstraint.deactivate([stackViewXConstraint, stackViewYConstraint])
        switch anchor.position {
        case .topLeft:
            itemsStackView.add(arrangedViews: itemViews.reversed(), hidden: true)
            stackViewXConstraint = itemsStackView.leadingAnchor.constraint(equalTo: anchor.guide.leadingAnchor, constant: self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.topAnchor.constraint(equalTo: currentAnchor.guide.bottomAnchor, constant: self.configuration.spacing)
        case .topRight:
            itemsStackView.add(arrangedViews: itemViews.reversed(), hidden: true)
            stackViewXConstraint = itemsStackView.trailingAnchor.constraint(equalTo: anchor.guide.trailingAnchor, constant: -self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.topAnchor.constraint(equalTo: currentAnchor.guide.bottomAnchor, constant: self.configuration.spacing)
        case .bottomLeft:
            itemsStackView.add(arrangedViews: itemViews, hidden: true)
            stackViewXConstraint = itemsStackView.leadingAnchor.constraint(equalTo: anchor.guide.leadingAnchor, constant: self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.bottomAnchor.constraint(equalTo: currentAnchor.guide.topAnchor, constant: -self.configuration.spacing)
        case .bottomRight:
            itemsStackView.add(arrangedViews: itemViews, hidden: true)
            stackViewXConstraint = itemsStackView.trailingAnchor.constraint(equalTo: anchor.guide.trailingAnchor, constant: -self.configuration.itemMargin)
            stackViewYConstraint = itemsStackView.bottomAnchor.constraint(equalTo: currentAnchor.guide.topAnchor, constant: -self.configuration.spacing)
        }
        NSLayoutConstraint.activate([stackViewXConstraint, stackViewYConstraint])
        
        itemViews.forEach { $0.orientation = currentAnchor.position.xOrientation }
    }
}
