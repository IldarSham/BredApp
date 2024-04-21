//
//  InsetLabel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 30.03.2024.
//

import UIKit

class InsetLabel: UILabel {
    
    // MARK: - Properties
    
    private let insets: UIEdgeInsets
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
    
    // MARK: - Initialization
    
    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
}
