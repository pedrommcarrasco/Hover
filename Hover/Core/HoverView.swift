//
//  HoverView.swift
//  Hover
//
//  Created by Pedro Carrasco on 11/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverView
class HoverView: UIView {
    
    // MARK: Outlets
    private let button = UIButton()
    private let anchorGuides: [UIView]

    // MARK: Private Properties
    private let buttonSize: CGFloat
    private let anchors: [HoverPosition]

    private let panRecognizer = UIPanGestureRecognizer()
    private var anchorCenters: [CGPoint] {
        return anchorGuides.map { $0.center }
    }

    // MARK: Lifecycle
    init(buttonSize: CGFloat, anchors: [HoverPosition]) {
        self.buttonSize = buttonSize
        self.anchors = anchors
        self.anchorGuides = anchors.map { _ in return UIView() }
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
}

// MARK: - Configuration
private extension HoverView {

    func addSubviews() {
        addSubview(button)
        anchorGuides.forEach { self.addSubview($0) }
    }

    func defineConstraints() {
        zip(self.anchors, self.anchorGuides).forEach {
            $1.translatesAutoresizingMaskIntoConstraints = false
            $1.widthAnchor.constraint(equalToConstant: self.buttonSize)
            $1.heightAnchor.constraint(equalToConstant: self.buttonSize)
            $0.configurePosition(of: $1, inside: self)
        }

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: self.buttonSize)
        button.heightAnchor.constraint(equalToConstant: self.buttonSize)
    }

    func setupSubviews() {

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(from:)))
        button.addGestureRecognizer(panRecognizer)
    }
}

// MARK: - Gestures
private extension HoverView {

    @objc
    func onPan(from recognizer: UIPanGestureRecognizer) {

    }
}
