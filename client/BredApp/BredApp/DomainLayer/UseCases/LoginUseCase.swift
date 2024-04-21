//
//  LoginUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.02.2024.
//

import Foundation

typealias LoginUseCaseType = UseCaseAsync<RemoteUserSession>

class LoginUseCase: UseCaseAsync {
    
    // MARK: - Properties
    
    private let username: String
    private let password: String
    
    private let accountValidator: AccountValidatorProtocol
    
    private let remoteAPI: AuthRemoteAPIProtocol
    private let dataStore: UserSessionDataStoreProtocol
    
    // MARK: - Initialization
    
    init(
        username: String,
        password: String,
        accountValidator: AccountValidatorProtocol,
        remoteAPI: AuthRemoteAPIProtocol,
        dataStore: UserSessionDataStoreProtocol
    ) {
        self.username = username
        self.password = password
        self.accountValidator = accountValidator
        self.remoteAPI = remoteAPI
        self.dataStore = dataStore
    }
    
    // MARK: - Methods
    
    func start() async throws -> RemoteUserSession {
        try validateAccount(username: username, 
                            password: password)
        
        let userSession = try await remoteAPI.signIn(username: username,
                                                     password: password)
        try dataStore.save(userSession: userSession)
        
        return userSession
    }
    
    private func validateAccount(username: String, password: String) throws {
        try accountValidator.validateUsername(username)
        try accountValidator.validatePassword(password)
    }
}

protocol LoginUseCaseFactory {
    
    func makeLoginUseCase(username: String, password: String) -> any LoginUseCaseType
}
