//
//  StartCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 11.01.2024.
//

import UIKit

class StartCoordinator: Coordinator {
    
    // MARK: - Properties
    let router: Router
    
    // Factories
    let startViewControllerFactory: StartViewControllerFactory
    let loginCoordinatorFactory: LoginCoordinatorFactory
    let signedInCoordinatorFactory: SignedInCoordinatorFactory
    
    // MARK: - Initialization
    init(router: Router,
         startViewControllerFactory: StartViewControllerFactory,
         loginCoordinatorFactory: LoginCoordinatorFactory,
         signedInCoordinatorFactory: SignedInCoordinatorFactory) {
        self.router = router
        self.startViewControllerFactory = startViewControllerFactory
        self.loginCoordinatorFactory = loginCoordinatorFactory
        self.signedInCoordinatorFactory = signedInCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = startViewControllerFactory.makeStartViewController(delegate: self)
        router.push(viewController)
    }
}

protocol StartCoordinatorFactory {
    
    func makeStartCoordinator(router: Router) -> Coordinator
}

// MARK: - StartFlowDelegate
extension StartCoordinator: StartFlowDelegate {
    
    func userNeedsToAuthenticate() {
        let coordinator = loginCoordinatorFactory.makeLoginCoordinator(router: router)
        coordinator.start()
    }
    
    func userIsAuthenticated(userSession: RemoteUserSession) {
        let coordinator = signedInCoordinatorFactory.makeSignedInCoordinator(
            router: router,
            session: userSession
        )
        coordinator.start()
    }
}
