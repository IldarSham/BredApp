//
//  MessagesRemoteAPI.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 08.03.2024.
//

import Foundation

protocol MessagesRemoteAPIProtocol {
    func createMessage(threadId: Int, content: String, files: [FileContainer]?) async throws -> Message
}

class MessagesRemoteAPI: MessagesRemoteAPIProtocol {
    
    private let userSession: RemoteUserSession
    
    private let apiManager: RemoteAPIManagerProtocol
    
    init(userSession: RemoteUserSession, apiManager: RemoteAPIManagerProtocol) {
        self.userSession = userSession
        self.apiManager = apiManager
    }
    
    func createMessage(threadId: Int, content: String, files: [FileContainer]?) async throws -> Message {
        let request = CreateMessageRequest(
            threadId: threadId,
            content: content,
            files: files
        )
        return try await apiManager.callAPI(with: request, authToken: userSession.token)
    }
}
