//
//  AppDependencyContainer.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 10.12.2023.
//

import UIKit

class AppDependencyContainer {
    
    // MARK: - Properties
    
    // Long-lived dependencies
    let userSessionDataStore: UserSessionDataStoreProtocol
    let apiManager: RemoteAPIManagerProtocol
    
    init() {
        func makeUserSessionDataStore() -> UserSessionDataStoreProtocol {
            let userSessionCoding: UserSessionCoding = UserSessionPropertyListCoder()
            return UserSessionDataStore(userSessionCoder: userSessionCoding)
        }
        
        func makeAPIManager() -> RemoteAPIManagerProtocol {
            let urlSessionManager = makeURLSessionManager()
            return RemoteAPIManager(urlSessionManager: urlSessionManager)
        }
        
        func makeURLSessionManager() -> URLSessionManagerProtocol {
            return URLSessionManager()
        }
        
        self.userSessionDataStore = makeUserSessionDataStore()
        self.apiManager = makeAPIManager()
    }
    
    func makeAccountValidator() -> AccountValidatorProtocol {
        return AccountValidator()
    }
    
    func makeAuthRemoteAPI() -> AuthRemoteAPIProtocol {
        return AuthRemoteAPI(apiManager: apiManager)
    }
}

// MARK: - StartViewControllerFactory
extension AppDependencyContainer: StartViewControllerFactory {
    
    func makeStartViewController(delegate: StartFlowDelegate) -> StartViewController {
        let viewModel = makeStartViewModel(delegate: delegate)
        return StartViewController(viewModel: viewModel)
    }
    
    func makeStartViewModel(delegate: StartFlowDelegate) -> StartViewModel {
        return StartViewModel(delegate: delegate,
                              loadUserSessionUseCaseFactory: self)
    }
}

// MARK: - StartCoordinatorFactory
extension AppDependencyContainer: StartCoordinatorFactory {
    
    func makeStartCoordinator(router: Router) -> Coordinator {
        return StartCoordinator(router: router,
                                startViewControllerFactory: self,
                                loginCoordinatorFactory: self,
                                signedInCoordinatorFactory: self)
    }
}

// MARK: - LoadUserSessionUseCaseFactory
extension AppDependencyContainer: LoadUserSessionUseCaseFactory {
    
    func makeLoadUserSessionUseCase() -> any LoadUserSessionUseCaseType {
        return LoadUserSessionUseCase(dataStore: userSessionDataStore)
    }
}

// MARK: - LoginViewControllerFactory
extension AppDependencyContainer: LoginViewControllerFactory {
    
    func makeLoginViewController(delegate: LoginFlowDelegate) -> LoginViewController {
        let viewModel = makeLoginViewModel(delegate: delegate)
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeLoginViewModel(delegate: LoginFlowDelegate) -> LoginViewModel {
        return LoginViewModel(delegate: delegate,
                              loginUseCaseFactory: self)
    }
}

// MARK: - LoginCoordinatorFactory
extension AppDependencyContainer: LoginCoordinatorFactory {
    
    func makeLoginCoordinator(router: Router) -> Coordinator {
        return LoginCoordinator(router: router,
                                loginViewControllerFactory: self,
                                signUpCoordinatorFactory: self,
                                signedInCoordinatorFactory: self)
    }
}
 
// MARK: - SignUpViewControllerFactory
extension AppDependencyContainer: SignUpViewControllerFactory {
    
    func makeSignUpViewController(delegate: SignUpFlowDelegate) -> SignUpViewController {
        let viewModel = makeSignUpViewModel(delegate: delegate)
        return SignUpViewController(viewModel: viewModel)
    }
    
    func makeSignUpViewModel(delegate: SignUpFlowDelegate) -> SignUpViewModel {
        return SignUpViewModel(delegate: delegate,
                               signUpUseCaseFactory: self)
    }
}

// MARK: - SignUpCoordinatorFactory
extension AppDependencyContainer: SignUpCoordinatorFactory {
    
    func makeSignUpCoordinator(router: Router) -> Coordinator {
        return SignUpCoordinator(router: router, 
                                 signUpViewControllerFactory: self,
                                 signedInCoordinatorFactory: self)
    }
}

// MARK: - SignUpUseCaseFactory
extension AppDependencyContainer: SignUpUseCaseFactory {
    
    func makeSignUpUseCase(newAccount: NewAccount) -> any SignUpUseCaseType {
        let validator = makeAccountValidator()
        let remoteAPI = makeAuthRemoteAPI()
        return SignUpUseCase(newAccount: newAccount,
                             accountValidator: validator,
                             remoteAPI: remoteAPI,
                             dataStore: userSessionDataStore)
    }
}

// MARK: - LoginUseCaseFactory
extension AppDependencyContainer: LoginUseCaseFactory {
    
    func makeLoginUseCase(username: String, password: String) -> any LoginUseCaseType {
        let validator = makeAccountValidator()
        let remoteAPI = makeAuthRemoteAPI()
        return LoginUseCase(username: username,
                            password: password, 
                            accountValidator: validator,
                            remoteAPI: remoteAPI,
                            dataStore: userSessionDataStore)
    }
}

// MARK: - SignedInCoordinatorFactory
extension AppDependencyContainer: SignedInCoordinatorFactory {
    
    func makeSignedInCoordinator(router: Router, session: RemoteUserSession) -> Coordinator {
        let dependencyContainer = SignedInDependencyContainer(userSession: session, appDependencyContainer: self)
        return dependencyContainer.makeSignedInCoordinator(router: router)
    }
}
