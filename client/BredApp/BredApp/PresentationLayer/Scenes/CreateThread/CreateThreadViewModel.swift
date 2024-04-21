//
//  CreateThreadViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 07.02.2024.
//

import Foundation
import Combine
import UIKit

protocol CreateThreadFlowDelegate {
    func didTapCloseButton()
    func didCreateThread(threadPreview: ThreadPreview)
}

class CreateThreadViewModel: BaseCreateMessageViewModel {
    
    // MARK: - Properties
    
    let delegate: CreateThreadFlowDelegate
    
    // Factories
    let createThreadUseCaseFactory: CreateThreadUseCaseFactory
    
    // Input fields
    var titleText = ""

    // MARK: - Initialization
    
    init(delegate: CreateThreadFlowDelegate, createThreadUseCaseFactory: CreateThreadUseCaseFactory) {
        self.delegate = delegate
        self.createThreadUseCaseFactory = createThreadUseCaseFactory
    }
    
    // MARK: - Public Methods
    
    override func send() {
        let newThread = NewThread(
            title: titleText,
            content: messageText,
            attachments: convertPhotosToAttachments())
        let useCase = createThreadUseCaseFactory.makeCreateThreadUseCase(newThread: newThread, 
                                                                         onStart: indicateProcessing)
        Task {
            defer { indicateFinishProcessing() }
            
            do {
                let createdThread = try await useCase.start()
                await handleCreateThreadSuccess(createdThread: createdThread)
            } catch {
                await handleCreateThreadFailure(error: error)
            }
        }
    }
    
    override func close() {
        delegate.didTapCloseButton()
    }
    
    // MARK: - Handlers
    
    @MainActor
    private func handleCreateThreadSuccess(createdThread: ThreadPreview) {
        delegate.didCreateThread(threadPreview: createdThread)
    }
    
    @MainActor
    private func handleCreateThreadFailure(error: Error) {
        sendErrorMessage(error.localizedDescription)
    }
}
