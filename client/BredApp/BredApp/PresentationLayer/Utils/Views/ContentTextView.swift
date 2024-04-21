//
//  ContentTextView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 10.02.2024.
//

import UIKit

class ContentTextView: UITextView {
    
    // MARK: - Initialization
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        textContainerInset.left = Constants.leftInset
        font = UIFont.systemFont(ofSize: 17)
        layer.cornerRadius = 6.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.55
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constants
extension ContentTextView {
    
    enum Constants {
        static let leftInset = 5.0
    }
}
