//
//  ContentSizeButton.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 10.03.2024.
//

import UIKit

class ContentSizeButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        return titleLabel?.intrinsicContentSize ?? super.intrinsicContentSize
    }
}
