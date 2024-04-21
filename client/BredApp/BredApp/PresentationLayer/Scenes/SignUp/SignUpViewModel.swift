//
//  SignUpViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.01.2024.
//

import Foundation
import Combine

protocol SignUpFlowDelegate: AnyObject {
    func userDidSignUp(session: RemoteUserSession)
    func didTapAlreadyHaveAccountButton()
}

class SignUpViewModel {
    
    // MARK: - Properties
    
    let delegate: SignUpFlowDelegate
    
    // Factories
    let signUpUseCaseFactory: SignUpUseCaseFactory
    
    // Input fields
    var username = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    var errorMessages: AnyPublisher<AlertMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<AlertMessage, Never>()
    
    @Published private(set) var activityIndicatorAnimating = false
    
    // MARK: - Initialization
    
    init(delegate: SignUpFlowDelegate, signUpUseCaseFactory: SignUpUseCaseFactory) {
        self.delegate = delegate
        self.signUpUseCaseFactory = signUpUseCaseFactory
    }
    
    // MARK: - Methods
    
    @objc
    func signUp() {
        let newAccount = NewAccount(
            username: username,
            email: email,
            password: password,
            confirmPassword: confirmPassword)
        let useCase = signUpUseCaseFactory.makeSignUpUseCase(newAccount: newAccount)
        
        Task {
            activityIndicatorAnimating = true
            defer { activityIndicatorAnimating = false }
            
            do {
                let userSession = try await useCase.start()
                await handleSignUpSuccess(userSession: userSession)
            } catch {
                await handleSignUpFailure(error: error)
            }
        }
    }
    
    // MARK: - Handlers
    
    @MainActor
    private func handleSignUpSuccess(userSession: RemoteUserSession) {
        delegate.userDidSignUp(session: userSession)
    }
    
    @MainActor
    private func handleSignUpFailure(error: Error) {
        let message = AlertMessage(title: L.ErrorMessage.title.localized,
                                   message: error.localizedDescription)
        errorMessagesSubject.send(message)
    }
    
    @objc
    func alreadyHaveAccount() {
        delegate.didTapAlreadyHaveAccountButton()
    }
}
