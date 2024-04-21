//
//  Alertable.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 01.02.2024.
//

import UIKit

protocol Alertable {
    func presentAlert(title: String?, message: String?, buttonTitle: String, completion: (() -> Void)?)
}

extension Alertable where Self: UIViewController {
    func presentAlert(title: String?, message: String?, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            completion?()
        }))
        present(alertController, animated: true, completion: nil)
    }
}
