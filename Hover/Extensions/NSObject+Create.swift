//
//  NSObject+Create.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import Foundation

// MARK: - Create
extension NSObject {
    
    static func create<T>(_ setup: (T) -> Void) -> T where T: NSObject {
        let object = T()
        setup(object)
        return object
    }
}
