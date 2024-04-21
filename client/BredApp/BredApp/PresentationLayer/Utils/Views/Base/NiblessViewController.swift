//
//  NiblessViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 14.01.2024.
//

import UIKit

class NiblessViewController: UIViewController {
    
    // MARK: - Methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from nib is not supported")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
