//
//  SignedInDependencyContainer.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 04.02.2024.
//

import Foundation

class SignedInDependencyContainer {

    // MARK: - Properties
    
    let appDependencyContainer: AppDependencyContainer

    // From parent container
    let userSessionDataStore: UserSessionDataStoreProtocol
    let apiManager: RemoteAPIManagerProtocol

    // Context
    let userSession: RemoteUserSession
    
    // Long-lived dependencies
    let threadRemoteAPI: ThreadsRemoteAPIProtocol
    
    init(userSession: RemoteUserSession, appDependencyContainer: AppDependencyContainer) {
        func makeThreadRemoteAPI(apiManager: RemoteAPIManagerProtocol) -> ThreadsRemoteAPIProtocol {
            return ThreadsRemoteAPI(userSession: userSession, apiManager: apiManager)
        }
        
        self.appDependencyContainer = appDependencyContainer
        self.userSession = userSession
        self.userSessionDataStore = appDependencyContainer.userSessionDataStore
        self.apiManager = appDependencyContainer.apiManager
        self.threadRemoteAPI = makeThreadRemoteAPI(apiManager: self.apiManager)
    }
    
    func makeSignedInCoordinator(router: Router) -> Coordinator {
        return SignedInCoordinator(router: router,
                                   signedInViewControllerFactory: self, 
                                   threadListCoordinatorFactory: self)
    }
    
    func makeAttachmentsConversionService() -> AttachmentsConversionServiceProtocol {
        return AttachmentsConversionService()
    }
}

// MARK: - SignedInViewControllerFactory
extension SignedInDependencyContainer: SignedInViewControllerFactory {

    func makeSignedInViewController(delegate: SignedInFlowDelegate) -> SignedInViewController {
        let viewModel = makeSignedInViewModel(delegate: delegate)
        return SignedInViewController(viewModel: viewModel)
    }
    
    func makeSignedInViewModel(delegate: SignedInFlowDelegate) -> SignedInViewModel {
        return SignedInViewModel(delegate: delegate)
    }
}

// MARK: - ThreadListCoordinatorFactory
extension SignedInDependencyContainer: ThreadListCoordinatorFactory {
    
    func makeThreadListCoordinator(router: Router) -> Coordinator {
        return ThreadListCoordinator(router: router,
                                     threadListViewControllerFactory: self, 
                                     settingsCoordinatorFactory: self,
                                     createThreadCoordinatorFactory: self,
                                     threadCoordinatorFactory: self)
    }
}

// MARK: - ThreadListViewControllerFactory
extension SignedInDependencyContainer: ThreadListViewControllerFactory {
    
    func makeThreadListViewController(delegate: ThreadListFlowDelegate) -> ThreadListViewController {
        let viewModel = makeThreadListViewModel(delegate: delegate)
        return ThreadListViewController(viewModel: viewModel)
    }
    
    func makeThreadListViewModel(delegate: ThreadListFlowDelegate) -> ThreadListViewModel {
        return ThreadListViewModel(delegate: delegate,
                                   loadThreadListUseCaseFactory: self)
    }
}

// MARK: - LoadThreadListUseCaseFactory
extension SignedInDependencyContainer: LoadThreadListUseCaseFactory {
    
    func makeLoadThreadListUseCase(page: Int, per: Int) -> any LoadThreadListUseCaseType {
        return LoadThreadListUseCase(page: page, 
                                     per: per,
                                     remoteAPI: threadRemoteAPI)
    }
}

// MARK: - SettingsViewControllerFactory
extension SignedInDependencyContainer: SettingsViewControllerFactory {
    
    func makeSettingsViewController(delegate: SettingsFlowDelegate) -> SettingsViewController {
        let viewModel = makeSettingsViewModel(delegate: delegate)
        return SettingsViewController(viewModel: viewModel)
    }
    
    func makeSettingsViewModel(delegate: SettingsFlowDelegate) -> SettingsViewModel {
        return SettingsViewModel(delegate: delegate,
                                 signOutUseCaseFactory: self)
    }
}

// MARK: - SettingsCoordinatorFactory
extension SignedInDependencyContainer: SettingsCoordinatorFactory {
    
    func makeSettingsCoordinator(router: Router) -> Coordinator {
        return SettingsCoordinator(router: router,
                                   settingsViewControllerFactory: self, 
                                   loginCoordinatorFactory: appDependencyContainer)
    }
}

// MARK: - SignOutUseCaseFactory
extension SignedInDependencyContainer: SignOutUseCaseFactory {
    
    func makeSignOutUseCase() -> any SignOutUseCaseType {
        return SignOutUseCase(dataStore: userSessionDataStore)
    }
}

// MARK: - CreateThreadViewControllerFactory
extension SignedInDependencyContainer: CreateThreadViewControllerFactory {
    
    func makeCreateThreadViewController(delegate: CreateThreadFlowDelegate) -> CreateThreadViewController {
        let viewModel = makeCreateThreadViewModel(delegate: delegate)
        return CreateThreadViewController(viewModel: viewModel)
    }
    
    func makeCreateThreadViewModel(delegate: CreateThreadFlowDelegate) -> CreateThreadViewModel {
        return CreateThreadViewModel(delegate: delegate, 
                                     createThreadUseCaseFactory: self)
    }
}

// MARK: - CreateThreadUseCaseFactory
extension SignedInDependencyContainer: CreateThreadUseCaseFactory {
    
    func makeCreateThreadUseCase(newThread: NewThread, onStart: (() -> Void)?) -> any CreateThreadUseCaseType {
        let validator = makeNewThreadValidator()
        let attachmentsConversionService = makeAttachmentsConversionService()
        return CreateThreadUseCase(newThread: newThread,
                                   newThreadValidator: validator, 
                                   attachmentsConversionService: attachmentsConversionService,
                                   remoteAPI: threadRemoteAPI,
                                   onStart: onStart)
    }
    
    func makeNewThreadValidator() -> NewThreadValidatorProtocol {
        return NewThreadValidator()
    }
}

// MARK: - CreateThreadCoordinatorFactory
extension SignedInDependencyContainer: CreateThreadCoordinatorFactory {
    
    func makeCreateThreadCoordinator(
        createdThreadHandler: @escaping CreatedThreadHandler,
        router: Router
    ) -> Coordinator {
        return CreateThreadCoordinator(createdThreadHandler: createdThreadHandler,
                                       router: router,
                                       createThreadViewControllerFactory: self)
    }
}

// MARK: - SignedInDependencyContainer
extension SignedInDependencyContainer: ThreadViewControllerFactory {
    
    func makeThreadViewController(threadId: Int, delegate: ThreadFlowDelegate) -> ThreadViewController {
        let viewModel = ThreadViewModel(threadId: threadId,
                                        delegate: delegate,
                                        loadThreadByIdUseCaseFactory: self)
        return ThreadViewController(viewModel: viewModel, createThreadViewControllerFactory: self)
    }
}

// MARK: - LoadThreadByIdUseCaseFactory
extension SignedInDependencyContainer: LoadThreadByIdUseCaseFactory {
    
    func makeLoadThreadByIdUseCase(threadId: Int) -> any LoadThreadByIdUseCaseType {
        return LoadThreadByIdUseCase(threadId: threadId,
                                     remoteAPI: threadRemoteAPI)
    }
}

// MARK: - ThreadCoordinatorFactory
extension SignedInDependencyContainer: ThreadCoordinatorFactory {
    
    func makeThreadCoordinator(threadId: Int, router: Router) -> Coordinator {
        return ThreadCoordinator(threadId: threadId,
                                 router: router,
                                 threadViewControllerFactory: self, 
                                 photoCoordinatorFactory: self, 
                                 createMessageCoordinatorFactory: self)
    }
}

// MARK: - PhotoViewControllerFactory
extension SignedInDependencyContainer: PhotoViewControllerFactory {
    
    func makePhotoViewController(photo: PhotoFile) -> PhotoViewController {
        let viewModel = makePhotoViewModel(photo: photo)
        return PhotoViewController(viewModel: viewModel)
    }
    
    func makePhotoViewModel(photo: PhotoFile) -> PhotoViewModel {
        return PhotoViewModel(photo: photo)
    }
}

// MARK: - PhotoCoordinatorFactory
extension SignedInDependencyContainer: PhotoCoordinatorFactory {
    
    func makePhotoCoordinator(photo: PhotoFile, router: Router) -> Coordinator {
        return PhotoCoordinator(photo: photo,
                                router: router,
                                photoViewControllerFactory: self)
    }
}

// MARK: - CreateMessageViewControllerFactory
extension SignedInDependencyContainer: CreateMessageViewControllerFactory {
    
    func makeCreateMessageViewController(threadId: Int, initialText: String?, delegate: CreateMessageFlowDelegate) -> CreateMessageViewController {
        let viewModel = CreateMessageViewModel(threadId: threadId,
                                               initialText: initialText,
                                               delegate: delegate,
                                               createMessageUseCaseFactory: self)
        return CreateMessageViewController(viewModel: viewModel)
    }
}

// MARK: - CreateMessageCoordinatorFactory
extension SignedInDependencyContainer: CreateMessageCoordinatorFactory {
    
    func makeCreateMessageCoordinator(
        threadId: Int,
        initialText: String?,
        messageSentHandler: @escaping MessageSentHandler,
        router: Router
    ) -> Coordinator {
        return CreateMessageCoordinator(threadId: threadId,
                                        initialText: initialText,
                                        messageSentHandler: messageSentHandler,
                                        router: router,
                                        createMessageViewControllerFactory: self)
    }
}

// MARK: - CreateMessageUseCaseFactory
extension SignedInDependencyContainer: CreateMessageUseCaseFactory {
    
    func makeCreateMessageUseCase(newMessage: NewMessage, onStart: (() -> Void)?) -> any CreateMessageUseCaseType {
        let attachmentsConversionService = makeAttachmentsConversionService()
        let remoteAPI = makeMessagesRemoteAPI()
        return CreateMessageUseCase(newMessage: newMessage,
                                    attachmentsConversionService: attachmentsConversionService,
                                    remoteAPI: remoteAPI,
                                    onStart: onStart)
    }
    
    func makeMessagesRemoteAPI() -> MessagesRemoteAPI {
        return MessagesRemoteAPI(userSession: userSession,
                                 apiManager: apiManager)
    }
}
