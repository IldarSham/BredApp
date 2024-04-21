//
//  NavigationRouter.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.01.2024.
//

import UIKit

class NavigationRouter: Router {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    
    // MARK: - Methods
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func present(_ viewController: UIViewController, 
                 presentationStyle: UIModalPresentationStyle,
                 transitionStyle: UIModalTransitionStyle,
                 animated: Bool) {
        viewController.modalPresentationStyle = presentationStyle
        viewController.modalTransitionStyle = transitionStyle
        navigationController.present(viewController, animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func setRootViewController(_ viewController: UIViewController, hideBar: Bool, animated: Bool) {
        navigationController.setViewControllers([viewController], animated: animated)
        navigationController.isNavigationBarHidden = hideBar
    }
}
