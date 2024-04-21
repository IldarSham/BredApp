//
//  NiblessView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 20.12.2023.
//

import UIKit

class NiblessView: UIView {
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Loading this view from nib is not supported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from nib is not supported")
    }
}
