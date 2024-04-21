//
//  UITextView+Extension.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.02.2024.
//

import UIKit
import Combine

extension UITextView {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
