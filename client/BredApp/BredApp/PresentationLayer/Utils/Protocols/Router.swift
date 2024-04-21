//
//  Router.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.01.2024.
//

import UIKit

protocol Router {
    var navigationController: UINavigationController { get }
    
    func present(_ viewController: UIViewController,
                 presentationStyle: UIModalPresentationStyle,
                 transitionStyle: UIModalTransitionStyle, 
                 animated: Bool)
    
    func push(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool)
    
    func setRootViewController(_ viewController: UIViewController, hideBar: Bool, animated: Bool)
}

extension Router {
    
    func present(_ viewController: UIViewController,
                 presentationStyle: UIModalPresentationStyle = .formSheet,
                 transitionStyle: UIModalTransitionStyle = .coverVertical,
                 animated: Bool = true) {
        present(viewController, presentationStyle: presentationStyle, transitionStyle: transitionStyle, animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        push(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    func setRootViewController(_ viewController: UIViewController, hideBar: Bool = false, animated: Bool = true) {
        setRootViewController(viewController, hideBar: hideBar, animated: animated)
    }
}
