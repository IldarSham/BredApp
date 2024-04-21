//
//  SignUpCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 30.01.2024.
//

import Foundation

class SignUpCoordinator: Coordinator {
    
    // MARK: - Properties
    var router: Router
    
    // Factories
    let signUpViewControllerFactory: SignUpViewControllerFactory
    let signedInCoordinatorFactory: SignedInCoordinatorFactory
    
    // MARK: - Initialization
    init(router: Router,
         signUpViewControllerFactory: SignUpViewControllerFactory,
         signedInCoordinatorFactory: SignedInCoordinatorFactory) {
        self.router = router
        self.signUpViewControllerFactory = signUpViewControllerFactory
        self.signedInCoordinatorFactory = signedInCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = signUpViewControllerFactory.makeSignUpViewController(delegate: self)
        router.push(viewController)
    }
}

protocol SignUpCoordinatorFactory {
    
    func makeSignUpCoordinator(router: Router) -> Coordinator
}

// MARK: - SignUpFlowDelegate
extension SignUpCoordinator: SignUpFlowDelegate {
    
    func userDidSignUp(session: RemoteUserSession) {
        let coordinator = signedInCoordinatorFactory.makeSignedInCoordinator(
            router: router,
            session: session
        )
        coordinator.start()
    }
    
    func didTapAlreadyHaveAccountButton() {
        router.popViewController()
    }
}
