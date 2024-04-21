//
//  AuthRemoteAPI.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 01.02.2024.
//

import Foundation

protocol AuthRemoteAPIProtocol {
    func signIn(username: String, password: String) async throws -> RemoteUserSession
    func signUp(account: NewAccount) async throws -> RemoteUserSession
}

class AuthRemoteAPI: AuthRemoteAPIProtocol {
    
    private let apiManager: RemoteAPIManagerProtocol
    
    init(apiManager: RemoteAPIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func signIn(username: String, password: String) async throws -> RemoteUserSession {
        let request = SignInRequest(
            username: username,
            password: password
        )
        return try await apiManager.callAPI(with: request)
    }
    
    func signUp(account: NewAccount) async throws -> RemoteUserSession {
        let request = SignUpRequest(
            username: account.username,
            email: account.email,
            password: account.password
        )
        return try await apiManager.callAPI(with: request)
    }
}
