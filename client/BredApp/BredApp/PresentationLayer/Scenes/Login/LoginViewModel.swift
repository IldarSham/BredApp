//
//  LoginViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.12.2023.
//

import Foundation
import Combine

protocol LoginFlowDelegate: AnyObject {
    func userDidSignIn(session: RemoteUserSession)
    func didTapSignUpButton()
}

class LoginViewModel {
    
    // MARK: - Properties
    
    private let delegate: LoginFlowDelegate
    
    // Factories
    private let loginUseCaseFactory: LoginUseCaseFactory
    
    // Input fields
    var username = ""
    var password = ""
    
    var errorMessages: AnyPublisher<AlertMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<AlertMessage, Never>()
    
    @Published private(set) var activityIndicatorAnimating = false
    
    // MARK: - Initialization
    
    init(delegate: LoginFlowDelegate, loginUseCaseFactory: LoginUseCaseFactory) {
        self.delegate = delegate
        self.loginUseCaseFactory = loginUseCaseFactory
    }
    
    // MARK: - Methods
    
    @objc
    func signIn() {
        let useCase = loginUseCaseFactory.makeLoginUseCase(
            username: username,
            password: password)
        
        Task {
            activityIndicatorAnimating = true
            defer { activityIndicatorAnimating = false }
            
            do {
                let userSession = try await useCase.start()
                await handleLoginSuccess(userSession: userSession)
            } catch {
                await handleLoginFailure(error: error)
            }
        }
    }
    
    // MARK: - Handlers
    
    @MainActor
    private func handleLoginSuccess(userSession: RemoteUserSession) {
        delegate.userDidSignIn(session: userSession)
    }
    
    @MainActor
    private func handleLoginFailure(error: Error) {
        let message = AlertMessage(title: L.ErrorMessage.title.localized,
                                   message: error.localizedDescription)
        errorMessagesSubject.send(message)
    }
    
    @objc
    func signUp() {
        delegate.didTapSignUpButton()
    }
}
