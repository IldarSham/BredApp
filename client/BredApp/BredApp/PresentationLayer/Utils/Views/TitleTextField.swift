//
//  TitleTextField.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 09.02.2024.
//

import UIKit

class TitleTextField: UITextField {
    
    // MARK: Properties
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: super.intrinsicContentSize.width,
            height: Constants.textFieldHeight
        )
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 6.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.55
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.leftInset, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.leftInset, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: Constants.leftInset, dy: 0)
    }
}

// MARK: - Constants
extension TitleTextField {
    
    enum Constants {
        static let textFieldHeight = 40.0
        static let leftInset = 10.0
    }
}
