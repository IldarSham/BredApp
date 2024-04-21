//
//  SettingsCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.03.2024.
//

import Foundation
import UIKit

class SettingsCoordinator: Coordinator {
    
    // MARK: Properties
    let router: Router
    
    // Factories
    let settingsViewControllerFactory: SettingsViewControllerFactory
    let loginCoordinatorFactory: LoginCoordinatorFactory
    
    // MARK: - Initialization
    init(router: Router,
         settingsViewControllerFactory: SettingsViewControllerFactory,
         loginCoordinatorFactory: LoginCoordinatorFactory) {
        self.router = router
        self.settingsViewControllerFactory = settingsViewControllerFactory
        self.loginCoordinatorFactory = loginCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = settingsViewControllerFactory.makeSettingsViewController(delegate: self)
        router.push(viewController)
    }
}

protocol SettingsCoordinatorFactory {
    
    func makeSettingsCoordinator(router: Router) -> Coordinator
}

// MARK: - SettingsFlowDelegate
extension SettingsCoordinator: SettingsFlowDelegate {
    
    func didTapSignOutRow() {
        let coordinator = loginCoordinatorFactory.makeLoginCoordinator(router: router)
        coordinator.start()
    }
}
