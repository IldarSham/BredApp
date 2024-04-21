//
//  ThreadListViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 05.02.2024.
//

import Foundation
import Combine

protocol ThreadListFlowDelegate {
    func showCreateThreadScene(createdThreadHandler: @escaping CreatedThreadHandler)
    func showThreadScene(threadId: Int)
    func didTapSettingsButton()
}

class ThreadListViewModel {
    
    // MARK: - Properties
    
    private let delegate: ThreadListFlowDelegate
    private let loadThreadListUseCaseFactory: LoadThreadListUseCaseFactory
    
    private var currentPage = 1
    private let itemsPerPage = 5
    private var isAllThreadsLoaded = false
    
    private var threads: [ThreadPreview] = []
        
    // Publishers
    var reloadData: AnyPublisher<Void, Never> {
        reloadDataSubject.eraseToAnyPublisher()
    }
    var errorMessages: AnyPublisher<AlertMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
    
    // Subjects
    private var reloadDataSubject = PassthroughSubject<Void, Never>()
    private let errorMessagesSubject = PassthroughSubject<AlertMessage, Never>()
    
    @Published private(set) var isLoadingInProgress = false
        
    // MARK: - Initialization
    
    init(delegate: ThreadListFlowDelegate, loadThreadListUseCaseFactory: LoadThreadListUseCaseFactory) {
        self.delegate = delegate
        self.loadThreadListUseCaseFactory = loadThreadListUseCaseFactory
    }
    
    // MARK: - Methods
    
    func loadThreadList(isRefreshing: Bool = false) {
        guard !isLoadingInProgress && !isAllThreadsLoaded else {
            return
        }
        
        let useCase = loadThreadListUseCaseFactory.makeLoadThreadListUseCase(
            page: currentPage,
            per: itemsPerPage)
                
        Task {
            isLoadingInProgress = true
            defer { isLoadingInProgress = false }
            
            do {
                if isRefreshing {
                    /// heavy post request simulation
                    try await Task.sleep(
                        nanoseconds: 1 * 1_000_000_000)
                }
                
                let response = try await useCase.start()
                await handleLoadThreadListSuccess(response: response, isRefreshing: isRefreshing)
            } catch {
                await handleLoadThreadListFailure(error: error)
            }
        }
    }
    
    @MainActor
    private func handleLoadThreadListSuccess(response: Page<ThreadPreview>, isRefreshing: Bool) {
        currentPage += 1
        threads = isRefreshing ? response.items : threads + response.items
        isAllThreadsLoaded = threads.count >= response.metadata.total
        reloadDataSubject.send()
    }
    
    @MainActor
    private func handleLoadThreadListFailure(error: Error) {
        let message = AlertMessage(title: L.ErrorMessage.title.localized,
                                   message: error.localizedDescription)
        errorMessagesSubject.send(message)
    }
    
    private func handleCreatedThread(_ createdThread: ThreadPreview) {
        threads.insert(createdThread, 
                       at: 0)
        reloadDataSubject.send()
        delegate.showThreadScene(threadId: createdThread.threadId)
    }
    
    func threadsCount() -> Int {
        return threads.count
    }
    
    func getThreadCellModel(for index: Int) -> ThreadCellModel {
        let thread = threads[index]
        return ThreadCellModel(previewPhoto: thread.previewPhoto,
                               messagesCount: thread.messagesCount,
                               filesCount: thread.filesCount,
                               title: thread.title,
                               contentPreview: thread.content)
    }
    
    func refreshThreadList() {
        guard !isLoadingInProgress else {
            return
        }
        currentPage = 1
        isAllThreadsLoaded = false
        
        loadThreadList(isRefreshing: true)
    }
    
    func didSelectRowAt(index: Int) {
        delegate.showThreadScene(threadId: threads[index].threadId)
    }
    
    // MARK: - Buttons Handlers
    
    @objc
    func handleSettingsButtonTap() {
        delegate.didTapSettingsButton()
    }
    
    @objc
    func createThread() {
        delegate.showCreateThreadScene(createdThreadHandler: handleCreatedThread)
    }
}
