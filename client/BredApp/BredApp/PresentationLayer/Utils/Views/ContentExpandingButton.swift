//
//  ContentExpandingButton.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 22.03.2024.
//

import UIKit

class ContentExpandingButton: UIButton {
    
    var contentExpansion: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentExpansion.width,
                      height: size.height + contentExpansion.height)
    }
}
