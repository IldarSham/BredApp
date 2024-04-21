//
//  LoadThreadByIdUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.03.2024.
//

import Foundation

typealias LoadThreadByIdUseCaseType = UseCaseAsync<Thread>

class LoadThreadByIdUseCase: UseCaseAsync {
    
    // MARK: - Properties
    
    private let threadId: Int
    
    private let remoteAPI: ThreadsRemoteAPIProtocol
    
    // MARK: - Initialization
    
    init(threadId: Int, remoteAPI: ThreadsRemoteAPIProtocol) {
        self.threadId = threadId
        self.remoteAPI = remoteAPI
    }
    
    // MARK: - Methods
    
    func start() async throws -> Thread {
        return try await remoteAPI.getThreadById(threadId: threadId)
    }
}

protocol LoadThreadByIdUseCaseFactory {
    
    func makeLoadThreadByIdUseCase(threadId: Int) -> any LoadThreadByIdUseCaseType
}
