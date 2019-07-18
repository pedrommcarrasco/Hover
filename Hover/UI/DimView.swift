//
//  DimView.swift
//  Hover
//
//  Created by Pedro Carrasco on 16/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

final class DimView: UIView {

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DimView {
    
    func configure() {
        isUserInteractionEnabled = false
    }
}
