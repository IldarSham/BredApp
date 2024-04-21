//
//  CreateMessageViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 31.03.2024.
//

import Foundation
import UIKit
import Combine

protocol CreateMessageFlowDelegate {
    func didTapCloseButton()
    func didSendMessage(_ message: Message)
}

class CreateMessageViewModel: BaseCreateMessageViewModel {
    
    // MARK: - Properties
    
    private let delegate: CreateMessageFlowDelegate

    private let threadId: Int
    private let _initialText: String?
    
    var initialText: String? {
        return _initialText
    }
    
    // Factories
    private let createMessageUseCaseFactory: CreateMessageUseCaseFactory
    
    // MARK: - Initialization
    
    init(
        threadId: Int,
        initialText: String?,
        delegate: CreateMessageFlowDelegate,
        createMessageUseCaseFactory: CreateMessageUseCaseFactory
    ) {
        self.threadId = threadId
        self._initialText = initialText
        self.delegate = delegate
        self.createMessageUseCaseFactory = createMessageUseCaseFactory
    }
    
    // MARK: - Public Methods
    
    override func send() {
        let newMessage = NewMessage(
            threadId: threadId,
            content: messageText,
            attachments: convertPhotosToAttachments())
        let useCase = createMessageUseCaseFactory.makeCreateMessageUseCase(newMessage: newMessage,
                                                                           onStart: indicateProcessing)
        Task {
            defer { indicateFinishProcessing() }
            
            do {
                let message = try await useCase.start()
                await handleCreateMessageSuccess(message: message)
            } catch {
                await handleCreateMessageFailure(error: error)
            }
        }
    }
    
    override func close() {
        delegate.didTapCloseButton()
    }
    
    // MARK: - Handlers
    
    @MainActor
    private func handleCreateMessageSuccess(message: Message) {
        delegate.didSendMessage(message)
    }
    
    @MainActor
    private func handleCreateMessageFailure(error: Error) {
        sendErrorMessage(error.localizedDescription)
    }
}
