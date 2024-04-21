//
//  NSLayoutConstraint+withPriority.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 02.03.2024.
//

import UIKit

extension NSLayoutConstraint {
    
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
