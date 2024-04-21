//
//  CreateMessageCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 31.03.2024.
//

import Foundation

class CreateMessageCoordinator: Coordinator {
    
    // MARK: - Properties
    let router: Router
    
    // Input data
    let threadId: Int
    let initialText: String?
    
    let messageSentHandler: MessageSentHandler
    
    // Factories
    let createMessageViewControllerFactory: CreateMessageViewControllerFactory
    
    // MARK: - Initialization
    init(threadId: Int,
         initialText: String?,
         messageSentHandler: @escaping MessageSentHandler,
         router: Router,
         createMessageViewControllerFactory: CreateMessageViewControllerFactory) {
        self.threadId = threadId
        self.initialText = initialText
        self.messageSentHandler = messageSentHandler
        self.router = router
        self.createMessageViewControllerFactory = createMessageViewControllerFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = createMessageViewControllerFactory.makeCreateMessageViewController(
            threadId: threadId,
            initialText: initialText,
            delegate: self
        )
        router.push(viewController)
    }
}

typealias MessageSentHandler = (Message) -> Void

protocol CreateMessageCoordinatorFactory {
    
    func makeCreateMessageCoordinator(
        threadId: Int,
        initialText: String?,
        messageSentHandler: @escaping MessageSentHandler,
        router: Router
    ) -> Coordinator
}

// MARK: - CreateMessageFlowDelegate
extension CreateMessageCoordinator: CreateMessageFlowDelegate {
    
    func didTapCloseButton() {
        router.popViewController()
    }
    
    func didSendMessage(_ message: Message) {
        router.popViewController()
        messageSentHandler(message)
    }
}
