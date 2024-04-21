//
//  SignedInCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.02.2024.
//

import Foundation

class ThreadListCoordinator: Coordinator {
    
    // MARK: - Properties
    let router: Router
    
    // Factories
    let threadListViewControllerFactory: ThreadListViewControllerFactory
    let settingsCoordinatorFactory: SettingsCoordinatorFactory
    let createThreadCoordinatorFactory: CreateThreadCoordinatorFactory
    let threadCoordinatorFactory: ThreadCoordinatorFactory
    
    // MARK: - Intialization
    init(router: Router,
         threadListViewControllerFactory: ThreadListViewControllerFactory,
         settingsCoordinatorFactory: SettingsCoordinatorFactory,
         createThreadCoordinatorFactory: CreateThreadCoordinatorFactory,
         threadCoordinatorFactory: ThreadCoordinatorFactory) {
        self.router = router
        self.threadListViewControllerFactory = threadListViewControllerFactory
        self.settingsCoordinatorFactory = settingsCoordinatorFactory
        self.createThreadCoordinatorFactory = createThreadCoordinatorFactory
        self.threadCoordinatorFactory = threadCoordinatorFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = threadListViewControllerFactory.makeThreadListViewController(delegate: self)
        router.setRootViewController(viewController)
    }
}

protocol ThreadListCoordinatorFactory {
    
    func makeThreadListCoordinator(router: Router) -> Coordinator
}

// MARK: - SignedInFlowDelegate
extension ThreadListCoordinator: ThreadListFlowDelegate {

    func showCreateThreadScene(createdThreadHandler: @escaping CreatedThreadHandler) {
        let coordinator = createThreadCoordinatorFactory.makeCreateThreadCoordinator(
            createdThreadHandler: createdThreadHandler,
            router: router
        )
        coordinator.start()
    }
    
    func showThreadScene(threadId: Int) {
        let coordinator = threadCoordinatorFactory.makeThreadCoordinator(
            threadId: threadId,
            router: router
        )
        coordinator.start()
    }
    
    func didTapSettingsButton() {
        let coordinator = settingsCoordinatorFactory.makeSettingsCoordinator(router: router)
        coordinator.start()
    }
}
