//
//  LoadUserSessionUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 26.01.2024.
//

import Foundation

typealias LoadUserSessionUseCaseType = UseCase<RemoteUserSession?>

class LoadUserSessionUseCase: UseCase {
    
    // MARK: - Properties
    
    private let dataStore: UserSessionDataStoreProtocol
    
    // MARK: - Initialization
    
    init(dataStore: UserSessionDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    // MARK: - Methods
    
    func start() throws -> RemoteUserSession? {
        return try dataStore.readUserSession()
    }
}

protocol LoadUserSessionUseCaseFactory {
    
    func makeLoadUserSessionUseCase() -> any LoadUserSessionUseCaseType
}
