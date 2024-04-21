//
//  CreateThreadUseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 12.02.2024.
//

import Foundation

typealias CreateThreadUseCaseType = UseCaseAsync<ThreadPreview>

class CreateThreadUseCase: UseCaseAsync {

    // MARK: - Properties
    
    private let newThread: NewThread
    
    private let newThreadValidator: NewThreadValidatorProtocol
    private let attachmentsConversionService: AttachmentsConversionServiceProtocol
    
    private let remoteAPI: ThreadsRemoteAPIProtocol
    
    private let onStart: (() -> Void)?
    
    // MARK: - Initialization
    
    init(
        newThread: NewThread,
        newThreadValidator: NewThreadValidatorProtocol,
        attachmentsConversionService: AttachmentsConversionServiceProtocol,
        remoteAPI: ThreadsRemoteAPIProtocol,
        onStart: (() -> Void)? = nil
    ) {
        self.newThread = newThread
        self.newThreadValidator = newThreadValidator
        self.attachmentsConversionService = attachmentsConversionService
        self.remoteAPI = remoteAPI
        self.onStart = onStart
    }
    
    // MARK: - Methods
    
    func start() async throws -> ThreadPreview {
        try validateNewThread(title: newThread.title, 
                              content: newThread.content)
        
        guard !newThread.attachments.isEmpty else {
            throw CreateThreadUseCaseError.attachmentsIsEmpty
        }
        
        onStart?()
        let createdThread = try await remoteAPI.createThread(
            title: newThread.title,
            content: newThread.content,
            files: attachmentsConversionService.convertToFileContainers(
                attachments: newThread.attachments)
        )
        
        return createdThread
    }
    
    private func validateNewThread(title: String, content: String) throws {
        try newThreadValidator.validateTitle(title)
        try newThreadValidator.validateContent(content)
    }
}

protocol CreateThreadUseCaseFactory {
    
    func makeCreateThreadUseCase(newThread: NewThread, onStart: (() -> Void)?)-> any CreateThreadUseCaseType
}

enum CreateThreadUseCaseError: Error {
    case attachmentsIsEmpty
}
