//
//  CreateThreadCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 07.02.2024.
//

import Foundation

class CreateThreadCoordinator: Coordinator {
    
    // MARK: - Properties
    let router: Router
    
    // Input data
    let createdThreadHandler: CreatedThreadHandler
    
    // Factories
    let createThreadViewControllerFactory: CreateThreadViewControllerFactory
    
    // MARK: - Initialization
    init(createdThreadHandler: @escaping CreatedThreadHandler,
         router: Router,
         createThreadViewControllerFactory: CreateThreadViewControllerFactory) {
        self.createdThreadHandler = createdThreadHandler
        self.router = router
        self.createThreadViewControllerFactory = createThreadViewControllerFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = createThreadViewControllerFactory.makeCreateThreadViewController(delegate: self)
        router.push(viewController)
    }
}

typealias CreatedThreadHandler = (ThreadPreview) -> Void

protocol CreateThreadCoordinatorFactory {
    
    func makeCreateThreadCoordinator(
        createdThreadHandler: @escaping CreatedThreadHandler,
        router: Router
    ) -> Coordinator
}

// MARK: - CreateThreadFlowDelegate
extension CreateThreadCoordinator: CreateThreadFlowDelegate {

    func didTapCloseButton() {
        router.popViewController()
    }
    
    func didCreateThread(threadPreview: ThreadPreview) {
        router.popViewController(animated: false)
        createdThreadHandler(threadPreview)
    }
}
