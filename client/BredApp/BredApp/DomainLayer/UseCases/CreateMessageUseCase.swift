//
//  CreateMessageUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 08.03.2024.
//

import Foundation

typealias CreateMessageUseCaseType = UseCaseAsync<Message>

class CreateMessageUseCase: UseCaseAsync {
    
    // MARK: - Properties
    
    private let newMessage: NewMessage
    
    private let attachmentsConversionService: AttachmentsConversionServiceProtocol
    private let remoteAPI: MessagesRemoteAPIProtocol
    
    private let onStart: (() -> Void)?
    
    // MARK: - Initialization
    
    init(
        newMessage: NewMessage,
        attachmentsConversionService: AttachmentsConversionServiceProtocol,
        remoteAPI: MessagesRemoteAPIProtocol,
        onStart: (() -> Void)? = nil
    ) {
        self.newMessage = newMessage
        self.attachmentsConversionService = attachmentsConversionService
        self.remoteAPI = remoteAPI
        self.onStart = onStart
    }
    
    // MARK: - Methods
    
    func start() async throws -> Message {
        guard !newMessage.content.isEmpty else {
            throw CreateMessageUseCaseError.contentIsEmpty
        }
        
        onStart?()
        let message = try await remoteAPI.createMessage(
            threadId: newMessage.threadId,
            content: newMessage.content,
            files: attachmentsConversionService.convertToFileContainers(
                attachments: newMessage.attachments)
        )
        
        return message
    }
}

protocol CreateMessageUseCaseFactory {
    
    func makeCreateMessageUseCase(newMessage: NewMessage, onStart: (() -> Void)?) -> any CreateMessageUseCaseType
}

enum CreateMessageUseCaseError: Error {
    case contentIsEmpty
}
