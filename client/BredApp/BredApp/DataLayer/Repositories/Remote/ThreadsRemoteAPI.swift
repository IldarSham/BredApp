//
//  ThreadsRemoteAPI.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 12.02.2024.
//

import Foundation

protocol ThreadsRemoteAPIProtocol {
    func getAllThreads(page: Int, per: Int) async throws -> Page<ThreadPreview>
    func getThreadById(threadId: Int) async throws -> Thread
    func createThread(title: String, content: String, files: [FileContainer]) async throws -> ThreadPreview
}

class ThreadsRemoteAPI: ThreadsRemoteAPIProtocol {
    
    private let userSession: RemoteUserSession
    
    private let apiManager: RemoteAPIManagerProtocol
    
    init(userSession: RemoteUserSession, apiManager: RemoteAPIManagerProtocol) {
        self.userSession = userSession
        self.apiManager = apiManager
    }
    
    func getAllThreads(page: Int, per: Int) async throws -> Page<ThreadPreview> {
        let request = ThreadListRequest(
            page: page,
            per: per
        )
        return try await apiManager.callAPI(with: request, authToken: userSession.token)
    }
    
    func getThreadById(threadId: Int) async throws -> Thread {
        let request = ThreadByIdRequest(
            threadId: threadId
        )
        return try await apiManager.callAPI(with: request, authToken: userSession.token)
    }
    
    func createThread(title: String, content: String, files: [FileContainer]) async throws -> ThreadPreview {
        let request = CreateThreadRequest(
            title: title,
            content: content,
            files: files
        )
        return try await apiManager.callAPI(with: request, authToken: userSession.token)
    }
}
