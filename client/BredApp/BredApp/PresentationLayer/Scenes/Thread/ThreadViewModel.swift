//
//  ThreadViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.03.2024.
//

import Foundation
import Combine

protocol ThreadFlowDelegate {
    func showCreateMessageScene(initialText: String?, 
                                messageSentHandler: @escaping MessageSentHandler)
    func didTapPhoto(_ photo: PhotoFile)
    func didTapBackButton()
}

class ThreadViewModel {
    
    // MARK: - Properties
    
    private let delegate: ThreadFlowDelegate
    private let loadThreadByIdUseCaseFactory: LoadThreadByIdUseCaseFactory
    
    private let threadId: Int
    private var thread: Thread?
    
    private var lastSentMessageId: Int?
    
    // Publishers
    var reloadData: AnyPublisher<Void, Never> {
        reloadDataSubject.eraseToAnyPublisher()
    }
    var selectedPhoto: AnyPublisher<PhotoFile, Never> {
        selectedPhotoSubject.eraseToAnyPublisher()
    }
    var selectedMessageRowIndex: AnyPublisher<Int, Never> {
        selectedMessageRowIndexSubject.eraseToAnyPublisher()
    }
    var scrollToTop: AnyPublisher<Void, Never> {
        scrollToTopSubject.eraseToAnyPublisher()
    }
    var errorMessages: AnyPublisher<AlertMessage, Never> {
        errorMessagesSubject.eraseToAnyPublisher()
    }
        
    // Subjects
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let selectedPhotoSubject = PassthroughSubject<PhotoFile, Never>()
    private let selectedMessageRowIndexSubject = PassthroughSubject<Int, Never>()
    private let scrollToTopSubject = PassthroughSubject<Void, Never>()
    private let errorMessagesSubject = PassthroughSubject<AlertMessage, Never>()
    
    @Published private(set) var isLoadingInProgress = false
    
    // MARK: - Initialization
    
    init(threadId: Int, delegate: ThreadFlowDelegate, loadThreadByIdUseCaseFactory: LoadThreadByIdUseCaseFactory) {
        self.threadId = threadId
        self.delegate = delegate
        self.loadThreadByIdUseCaseFactory = loadThreadByIdUseCaseFactory
    }
    
    // MARK: - Methods
    
    func loadThread(isRefreshing: Bool = false) {
        let useCase = loadThreadByIdUseCaseFactory.makeLoadThreadByIdUseCase(threadId: threadId)
        
        Task {
            isLoadingInProgress = true
            defer { isLoadingInProgress = false }
            
            do {
                if isRefreshing {
                    /// heavy post request simulation
                    try await Task.sleep(
                        nanoseconds: 1 * 1_000_000_000)
                }
                
                let thread = try await useCase.start()
                await handleLoadThreadSuccess(thread: thread)
            } catch {
                await handleLoadThreadFailure(error: error)
            }
        }
    }
    
    @MainActor
    private func handleLoadThreadSuccess(thread: Thread) {
        self.thread = thread
        self.reloadDataSubject.send()
    }
    
    @MainActor
    private func handleLoadThreadFailure(error: Error) {
        let message = AlertMessage(title: L.ErrorMessage.title.localized,
                                   message: error.localizedDescription)
        errorMessagesSubject.send(message)
    }
    
    private func handleSentMessage(_ message: Message) {
        lastSentMessageId = message.messageId
        refreshThread()
    }
    
    func getMessagesCount() -> Int {
        return thread?.messages.count ?? 0
    }
    
    func getMessageCellModel(for index: Int) -> MessageCellModel? {
        guard let message = thread?.messages[index] else {
            return nil
        }
        return MessageCellModel(
            username: message.from.username,
            date: dateString(for: message.createdAt ?? 0),
            messageId: message.messageId,
            messageNumber: index + 1,
            photoCellData: message.photo?.map {
                PhotoCellModel(photo: $0, sizeInKB: getSizeInKB(fileSize: $0.fileSize))
            },
            content: message.content,
            repliesByIds: message.repliesByIds)
    }
    
    func didTapMessageIdButton(messageId: Int) {
        delegate.showCreateMessageScene(initialText: formatInitialText(for: messageId),
                                        messageSentHandler: handleSentMessage)
    }
    
    func didTapPhoto(_ photo: PhotoFile) {
        delegate.didTapPhoto(photo)
    }
    
    func didTapReplyMessageIdButton(messageId: Int) {
        guard let index = getMessageIndex(by: messageId) else {
            return
        }
        selectedMessageRowIndexSubject.send(index)
    }
    
    func refreshThread() {
        guard !isLoadingInProgress else {
            return
        }
        loadThread(isRefreshing: true)
    }
    
    func tableReloaded() {
        if let lastSentMessageId = lastSentMessageId,
           let index = getMessageIndex(by: lastSentMessageId) {
            self.selectedMessageRowIndexSubject.send(index)
            self.lastSentMessageId = nil
        }
    }
    
    // MARK: - Buttons Handlers
    
    @objc
    func handleCreateMessageButtonTap() {
        delegate.showCreateMessageScene(initialText: nil,
                                        messageSentHandler: handleSentMessage)
    }

    @objc
    func handleBackButtonTap() {
        delegate.didTapBackButton()
    }
    
    @objc
    func handleTopButtonTap() {
        scrollToTopSubject.send()
    }
    
    @objc
    func handleRefreshButtonTap() {
        refreshThread()
    }
    
    // MARK: - Private Methods
    
    private func formatInitialText(for messageId: Int) -> String {
        return ">>\(messageId)\n"
    }
    
    private func getMessageIndex(by messageId: Int) -> Int? {
        guard let index = thread?.messages.firstIndex(where: { $0.messageId == messageId }) else {
            return nil
        }
        return index
    }
    
    private func dateString(for unixtime: Int) -> String {
        let date = Date(timeIntervalSince1970: .init(unixtime))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy E HH:mm:ss"
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: date)
    }
    
    private func getSizeInKB(fileSize: Int) -> String {
        let sizeInKB = Float(fileSize) / 1024.0
        return String(format: "%.1fКБ", sizeInKB)
    }
}
