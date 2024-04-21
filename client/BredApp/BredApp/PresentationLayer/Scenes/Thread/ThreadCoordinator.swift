//
//  ThreadCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.03.2024.
//

import Foundation

class ThreadCoordinator: Coordinator {

    // MARK: - Properties
    let router: Router
    
    // Input data
    let threadId: Int
    
    // Factories
    let threadViewControllerFactory: ThreadViewControllerFactory
    let photoCoordinatorFactory: PhotoCoordinatorFactory
    let createMessageCoordinatorFactory: CreateMessageCoordinatorFactory
    
    // MARK: - Initialization
    init(threadId: Int, 
         router: Router,
         threadViewControllerFactory: ThreadViewControllerFactory,
         photoCoordinatorFactory: PhotoCoordinatorFactory,
         createMessageCoordinatorFactory: CreateMessageCoordinatorFactory) {
        self.threadId = threadId
        self.router = router
        self.threadViewControllerFactory = threadViewControllerFactory
        self.photoCoordinatorFactory = photoCoordinatorFactory
        self.createMessageCoordinatorFactory = createMessageCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = threadViewControllerFactory.makeThreadViewController(
            threadId: threadId,
            delegate: self
        )
        router.push(viewController)
    }
}

protocol ThreadCoordinatorFactory {
    
    func makeThreadCoordinator(threadId: Int, router: Router) -> Coordinator
}

// MARK: - ThreadFlowDelegate
extension ThreadCoordinator: ThreadFlowDelegate {
    
    func showCreateMessageScene(initialText: String?, messageSentHandler: @escaping MessageSentHandler) {
        let coordinator = createMessageCoordinatorFactory.makeCreateMessageCoordinator(
            threadId: threadId,
            initialText: initialText,
            messageSentHandler: messageSentHandler,
            router: router
        )
        coordinator.start()
    }
    
    func didTapPhoto(_ photo: PhotoFile) {
        let coordinator = photoCoordinatorFactory.makePhotoCoordinator(
            photo: photo,
            router: router
        )
        coordinator.start()
    }
    
    func didTapBackButton() {
        router.popViewController()
    }
}
