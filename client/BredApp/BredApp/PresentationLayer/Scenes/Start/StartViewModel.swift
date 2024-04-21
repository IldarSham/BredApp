//
//  StartViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 01.01.2024.
//

import Combine

protocol StartFlowDelegate: AnyObject {
    func userNeedsToAuthenticate()
    func userIsAuthenticated(userSession: RemoteUserSession)
}

class StartViewModel {
    
    // MARK: - Properties
    
    private let delegate: StartFlowDelegate
            
    // Factories
    let loadUserSessionUseCaseFactory: LoadUserSessionUseCaseFactory
    
    var errorMessages: AnyPublisher<AlertMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    private let errorMessagesSubject = PassthroughSubject<AlertMessage, Never>()
    
    @Published private(set) var activityIndicatorAnimating = true
    
    // MARK: - Initialization
    
    init(delegate: StartFlowDelegate, loadUserSessionUseCaseFactory: LoadUserSessionUseCaseFactory) {
        self.delegate = delegate
        self.loadUserSessionUseCaseFactory = loadUserSessionUseCaseFactory
    }
    
    // MARK: - Public Methods
    
    func loadUserSession() {
        defer { activityIndicatorAnimating = false }
        
        let useCase = loadUserSessionUseCaseFactory.makeLoadUserSessionUseCase()
        do {
            let userSession = try useCase.start()
            handleLoadUserSessionSuccess(userSession: userSession)
        } catch {
            handleLoadUserSessionFailure(error: error)
        }
    }
    
    // MARK: - Handlers
    
    private func handleLoadUserSessionSuccess(userSession: RemoteUserSession?) {
        switch userSession {
        case .some(let userSession):
            delegate.userIsAuthenticated(userSession: userSession)
        case .none:
            delegate.userNeedsToAuthenticate()
        }
    }
    
    private func handleLoadUserSessionFailure(error: Error) {
        let message = AlertMessage(title: L.ErrorMessage.title.localized,
                                   message: error.localizedDescription)
        errorMessagesSubject.send(message)
    }
}
