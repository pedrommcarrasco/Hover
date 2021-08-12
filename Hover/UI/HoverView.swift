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
        static let animationDamping: CGFloat = 0.8
        static let animationResponse: CGFloat = 0.5
        static let animationDuration = 0.4
        static let enableAnimationDuration = 0.2
        static let anchorAnimationDuration = 0.15
        static let interItemSpacing: CGFloat = 12.0
        static let disabledAlpha: CGFloat = 0.75
        static let disabledTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    // MARK: State
    private enum State {
        case none
        case disappearing
        case pending
    }
    
    // MARK: Outlets
    private let button: HoverButton
    private var itemViews = [HoverItemView]() {
        didSet {
            animateState(to: false)
            itemsStackView.removeAll()
            itemsStackView.add(arrangedViews: itemViews, hidden: true)
            adapt(to: currentAnchor)
            itemViews.forEach { $0.onTap = onTapInButton }
        }
    }
    private let itemsStackView: UIStackView = .create {
        $0.spacing = Constant.interItemSpacing
        $0.axis = .vertical
        $0.isUserInteractionEnabled = false
    }
    private let dimView: DimView = .create {
        $0.alpha = 0.0
    }
    
    // MARK: Constraints
    private var stackViewXConstraint = NSLayoutConstraint()
    private var stackViewYConstraint = NSLayoutConstraint()
    
    // MARK: Properties
    public var items = [HoverItem]() {
        didSet {
            itemViews = items.reversed().map { HoverItemView(with: $0, configuration: configuration.itemConfiguration) }
        }
    }
    
    public var isEnabled = true {
        didSet {
            UIView.animate(withDuration: Constant.enableAnimationDuration) {
                self.button.alpha = self.isEnabled ? 1.0 : Constant.disabledAlpha
                self.button.transform = self.isEnabled ? .identity : Constant.disabledTransform
                self.button.isEnabled = self.isEnabled
            }
            
            if !isEnabled {
                animateState(to: false)
            }
        }
    }
    
    public var onPositionChange: ((HoverPosition) -> ())?
    
    // MARK: Private Properties
    private let anchors: [Anchor]
    private let configuration: HoverConfiguration
    private let panRecognizer = UIPanGestureRecognizer()
    private var state: State = .none
    private var isOpen = false
    private var offset = CGPoint.zero
    private var currentAnchor: Anchor {
        didSet {
            if state == .disappearing {
                state = .pending
            } else {
                adapt(to: currentAnchor)
            }
            
            onPositionChange?(currentAnchor.position)
        }
    }
    
    // MARK: Lifecycle
    public init(with configuration: HoverConfiguration = HoverConfiguration(), items: [HoverItem] = []) {
        
        guard !configuration.allowedPositions.isEmpty else {
            fatalError("`allowedPositions` can't be empty")
        }
        
        self.anchors = configuration.allowedPositions.map(Anchor.init)
        
        guard let currentAnchor = anchors.first(where: { $0.position == configuration.initialPosition }) else {
            fatalError("`allowedPositions` must contain the `initalPosition`")
        }
        
        defer { self.items = items }
        
        self.currentAnchor = currentAnchor
        self.configuration = configuration
        self.button = HoverButton(with: configuration.color, image: configuration.image, imageSizeRatio: configuration.imageSizeRatio)
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

public extension HoverView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            onTouchInDim()
            if state == .none { return nil }
        }
        return hitView
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
    }
    
    func defineConstraints() {
        anchors.forEach {
            $0.position.configurePosition(of: $0.guide, inside: self, with: self.configuration.padding)
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
        dimView.backgroundColor = configuration.dimColor
        
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(from:))))
        button.addTarget(self, action: #selector(onTapInButton), for: .touchUpInside)
    }
}

// MARK: - Gestures
private extension HoverView {
    
    func onTouchInDim() {
        animateState(to: false)
    }
    
    @objc
    func onTapInButton() {
        animateState(to: !isOpen)
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
            animator.addAnimations { self.button.center = self.currentAnchor.center }
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
        itemsStackView.isUserInteractionEnabled = isOpening

        let transform = imageExpandTransform(isOpening: isOpening)
        UIViewPropertyAnimator(duration: Constant.animationDuration, dampingRatio: Constant.animationDamping) {
            self.dimView.alpha = isOpening ? 1.0 : 0.0
            self.button.imageView.transform = transform
        }.startAnimation()
        
        anchor.position.yOrientation.reverseArrayIfNeeded(itemsStackView.arrangedSubviews).enumerated().forEach { (index, view) in
            let translationTransform = Calculator.translation(for: index, anchor: anchor)
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
            
            animator.startAnimation(afterDelay: Calculator.delay(for: index))
        }
    }

    private func imageExpandTransform(isOpening: Bool) -> CGAffineTransform {
        switch configuration.imageExpandAnimation {
        case .none:
            return .identity
            
        case .rotate(let radianValue):
            let factor: CGFloat

            switch (currentAnchor.position.xOrientation, currentAnchor.position.yOrientation) {
            case (.leftToRight, .bottomToTop),
                 (.rightToLeft, .topToBottom):
                factor = 1
            case (.leftToRight, .topToBottom),
                 (.rightToLeft, .bottomToTop):
                factor = -1
            }

            let rotationValue: CGFloat = radianValue * factor
            let rotationTransform = CGAffineTransform(rotationAngle: rotationValue)

            return isOpening ? rotationTransform : .identity
        }
    }
}

// MARK: - Conditional Constraints
private extension HoverView {
    
    func adapt(to anchor: Anchor) {
        NSLayoutConstraint.deactivate([stackViewXConstraint, stackViewYConstraint])
        switch anchor.position {
        case .topLeft:
            itemsStackView.add(arrangedViews: itemViews.reversed(), hidden: true)
            stackViewXConstraint = itemsStackView.leadingAnchor.constraint(equalTo: anchor.guide.leadingAnchor,
                                                                           constant: self.configuration.itemConfiguration.margin)
            stackViewYConstraint = itemsStackView.topAnchor.constraint(equalTo: currentAnchor.guide.bottomAnchor,
                                                                       constant: self.configuration.padding.bottom)
        case .topRight:
            itemsStackView.add(arrangedViews: itemViews.reversed(), hidden: true)
            stackViewXConstraint = itemsStackView.trailingAnchor.constraint(equalTo: anchor.guide.trailingAnchor,
                                                                            constant: -self.configuration.itemConfiguration.margin)
            stackViewYConstraint = itemsStackView.topAnchor.constraint(equalTo: currentAnchor.guide.bottomAnchor,
                                                                       constant: self.configuration.padding.bottom)
        case .bottomLeft:
            itemsStackView.add(arrangedViews: itemViews, hidden: true)
            stackViewXConstraint = itemsStackView.leadingAnchor.constraint(equalTo: anchor.guide.leadingAnchor,
                                                                           constant: self.configuration.itemConfiguration.margin)
            stackViewYConstraint = itemsStackView.bottomAnchor.constraint(equalTo: currentAnchor.guide.topAnchor,
                                                                          constant: -self.configuration.padding.top)
        case .bottomRight:
            itemsStackView.add(arrangedViews: itemViews, hidden: true)
            stackViewXConstraint = itemsStackView.trailingAnchor.constraint(equalTo: anchor.guide.trailingAnchor,
                                                                            constant: -self.configuration.itemConfiguration.margin)
            stackViewYConstraint = itemsStackView.bottomAnchor.constraint(equalTo: currentAnchor.guide.topAnchor,
                                                                          constant: -self.configuration.padding.top)
        }
        NSLayoutConstraint.activate([stackViewXConstraint, stackViewYConstraint])
        
        itemViews.forEach { $0.orientation = currentAnchor.position.xOrientation }
    }
}
