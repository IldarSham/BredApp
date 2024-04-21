//
//  SignUpUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.01.2024.
//

import Foundation

typealias SignUpUseCaseType = UseCaseAsync<RemoteUserSession>

class SignUpUseCase: UseCaseAsync {
    
    // MARK: - Properties
    
    private let newAccount: NewAccount
    
    private let accountValidator: AccountValidatorProtocol
    
    private let remoteAPI: AuthRemoteAPIProtocol
    private let dataStore: UserSessionDataStoreProtocol
        
    // MARK: - Initialization
    
    init(
        newAccount: NewAccount,
        accountValidator: AccountValidatorProtocol,
        remoteAPI: AuthRemoteAPIProtocol,
        dataStore: UserSessionDataStoreProtocol
    ) {
        self.newAccount = newAccount
        self.accountValidator = accountValidator
        self.remoteAPI = remoteAPI
        self.dataStore = dataStore
    }
    
    // MARK: - Methods
    
    func start() async throws -> RemoteUserSession {
        try validateAccount(newAccount)
        
        let userSession = try await remoteAPI.signUp(account: newAccount)
        try dataStore.save(userSession: userSession)
        
        return userSession
    }
    
    private func validateAccount(_ newAccount: NewAccount) throws {
        try accountValidator.validateUsername(newAccount.username)
        try accountValidator.validateEmail(newAccount.email)
        try accountValidator.validatePassword(newAccount.password)
        try accountValidator.validateConfirmPassword(newAccount.confirmPassword, password: newAccount.password)
    }
}

protocol SignUpUseCaseFactory {
    
    func makeSignUpUseCase(newAccount: NewAccount) -> any SignUpUseCaseType
}
