//
//  SignedInCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.02.2024.
//

import Foundation

class SignedInCoordinator: Coordinator {
    
    // MARK: - Properties
    let router: Router
    
    // Factories
    let signedInViewControllerFactory: SignedInViewControllerFactory
    let threadListCoordinatorFactory: ThreadListCoordinatorFactory
    
    // MARK: - Intialization
    init(router: Router,
         signedInViewControllerFactory: SignedInViewControllerFactory,
         threadListCoordinatorFactory: ThreadListCoordinatorFactory) {
        self.router = router
        self.signedInViewControllerFactory = signedInViewControllerFactory
        self.threadListCoordinatorFactory = threadListCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = signedInViewControllerFactory.makeSignedInViewController(delegate: self)
        router.setRootViewController(viewController)
    }
}

protocol SignedInCoordinatorFactory {
    
    func makeSignedInCoordinator(router: Router, session: RemoteUserSession) -> Coordinator
}

// MARK: - SignedInFlowDelegate
extension SignedInCoordinator: SignedInFlowDelegate {
    
    func didSignInAndNavigateToThreadList() {
        let coordinator = threadListCoordinatorFactory.makeThreadListCoordinator(router: router)
        coordinator.start()
    }
}
