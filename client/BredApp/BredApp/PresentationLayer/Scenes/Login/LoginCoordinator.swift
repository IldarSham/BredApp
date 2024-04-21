//
//  LoginCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 29.01.2024.
//

import Foundation

class LoginCoordinator: Coordinator {
    
    // MARK: - Properties
    let router: Router
    
    // Factories
    let loginViewControllerFactory: LoginViewControllerFactory
    let signUpCoordinatorFactory: SignUpCoordinatorFactory
    let signedInCoordinatorFactory: SignedInCoordinatorFactory
    
    // MARK: - Initialization
    init(router: Router,
         loginViewControllerFactory: LoginViewControllerFactory,
         signUpCoordinatorFactory: SignUpCoordinatorFactory,
         signedInCoordinatorFactory: SignedInCoordinatorFactory) {
        self.router = router
        self.loginViewControllerFactory = loginViewControllerFactory
        self.signUpCoordinatorFactory = signUpCoordinatorFactory
        self.signedInCoordinatorFactory = signedInCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = loginViewControllerFactory.makeLoginViewController(delegate: self)
        router.setRootViewController(viewController)
    }
}

protocol LoginCoordinatorFactory {
    
    func makeLoginCoordinator(router: Router) -> Coordinator
}

// MARK: - LoginFlowDelegate
extension LoginCoordinator: LoginFlowDelegate {
    
    func userDidSignIn(session: RemoteUserSession) {
        let coordinator = signedInCoordinatorFactory.makeSignedInCoordinator(
            router: router,
            session: session
        )
        coordinator.start()
    }
    
    func didTapSignUpButton() {
        let coordinator = signUpCoordinatorFactory.makeSignUpCoordinator(router: router)
        coordinator.start()
    }
}
