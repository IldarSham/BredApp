//
//  LoadThreadListUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 26.02.2024.
//

import Foundation

typealias LoadThreadListUseCaseType = UseCaseAsync<Page<ThreadPreview>>

class LoadThreadListUseCase: UseCaseAsync {
    
    // MARK: - Properties
    
    private let page: Int
    private let per: Int
    
    private let remoteAPI: ThreadsRemoteAPIProtocol
    
    // MARK: - Initialization
    
    init(page: Int, per: Int, remoteAPI: ThreadsRemoteAPIProtocol) {
        self.page = page
        self.per = per
        self.remoteAPI = remoteAPI
    }
    
    // MARK: - Methods
    
    func start() async throws -> Page<ThreadPreview> {
        return try await remoteAPI.getAllThreads(page: page, 
                                                 per: per)
    }
}

protocol LoadThreadListUseCaseFactory {
    
    func makeLoadThreadListUseCase(page: Int, per: Int) -> any LoadThreadListUseCaseType
}
