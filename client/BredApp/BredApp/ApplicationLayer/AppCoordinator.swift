//
//  AppCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 11.01.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let router: Router
    
    // Factories
    let startCoordinatorFactory: StartCoordinatorFactory
            
    // MARK: - Initialization
    init(router: Router, startCoordinatorFactory: StartCoordinatorFactory) {
        self.router = router
        self.startCoordinatorFactory = startCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let coordinator = startCoordinatorFactory.makeStartCoordinator(router: router)
        coordinator.start()
    }
}
