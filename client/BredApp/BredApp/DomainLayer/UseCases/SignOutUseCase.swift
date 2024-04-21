//
//  SignOutUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 04.02.2024.
//

import Foundation

typealias SignOutUseCaseType = UseCase<Void>
 
class SignOutUseCase: UseCase {
    
    // MARK: - Properties
    
    private let dataStore: UserSessionDataStoreProtocol
    
    // MARK: - Initialization
    
    init(dataStore: UserSessionDataStoreProtocol) {
        self.dataStore = dataStore
    }

    // MARK: - Methods
    
    func start() throws {
        try dataStore.deleteUserSession()
    }
}

protocol SignOutUseCaseFactory {
    
    func makeSignOutUseCase() -> any SignOutUseCaseType
}
