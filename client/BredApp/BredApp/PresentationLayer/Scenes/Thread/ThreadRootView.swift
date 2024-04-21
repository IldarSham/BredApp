//
//  ThreadRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.03.2024.
//

import UIKit
import Combine

class ThreadRootView: NiblessView {
    
    enum TableSection: Int, CaseIterable {
        case createMessage
        case messagesList
        case loadingStatus
        case footer
    }
    
    // MARK: - Properties
    
    let viewModel: ThreadViewModel
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.register(
            CreateMessageCell.self,
            forCellReuseIdentifier: CreateMessageCell.reuseIdentifier
        )
        
        tableView.register(
            MessageCell.self,
            forCellReuseIdentifier: MessageCell.reuseIdentifier
        )
        
        tableView.register(
            LoadingTableViewCell.self,
            forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier
        )
        
        tableView.register(
            FooterCell.self,
            forCellReuseIdentifier: FooterCell.reuseIdentifier
        )
        
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var lastSelectedRowIndexPath: IndexPath?
    
    // MARK: - Initialization
    
    init(viewModel: ThreadViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        bindViewModelToViews()
        constructHierarchy()
        activateConstraints()
    
        loadThread()
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        addSubview(tableView)
    }
    
    private func activateConstraints() {
        activateConstraintsTableView()
    }
    
    private func bindViewModelToViews() {
        bindTableViewReloadData()
        bindTableViewLoadingStatus()
        bindSelectedMessageIndex()
        bindScrollToTop()
    }
    
    private func loadThread() {
        viewModel.loadThread()
    }
}

// MARK: - Binding
extension ThreadRootView {
    
    private func bindTableViewReloadData() {
        viewModel
            .reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
                self?.viewModel.tableReloaded()
            }
            .store(in: &subscriptions)
    }
    
    private func bindTableViewLoadingStatus() {
        viewModel
            .$isLoadingInProgress
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.tableView.reloadSections(IndexSet(integer: TableSection.loadingStatus.rawValue), with: .none)
            }
            .store(in: &subscriptions)
    }
    
    private func bindSelectedMessageIndex() {
        viewModel
            .selectedMessageRowIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self else { return }
                
                let indexPath = IndexPath(row: index,
                                          section: TableSection.messagesList.rawValue)
                
                tableView.scrollToRow(at: indexPath,
                                      at: .top,
                                      animated: true)
                
                guard let cell = tableView.cellForRow(at: indexPath) as? MessageCell else {
                    lastSelectedRowIndexPath = indexPath
                    return
                }
                
                cell.select()
            }
            .store(in: &subscriptions)
    }
    
    private func bindScrollToTop() {
        viewModel
            .scrollToTop
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                            at: .top,
                                            animated: true)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - UITableViewDataSource
extension ThreadRootView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = TableSection(rawValue: section)
        switch section {
        case .createMessage:
            return 1
        case .messagesList:
            return viewModel.getMessagesCount()
        case .loadingStatus where viewModel.isLoadingInProgress:
            return 1
        case .footer:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .createMessage:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateMessageCell.reuseIdentifier,
                                                     for: indexPath) as! CreateMessageCell
            cell.createMessageButton
                .addTarget(viewModel, 
                           action: #selector(ThreadViewModel.handleCreateMessageButtonTap),
                           for: .touchUpInside)
            
            return cell
        case .messagesList:
            guard let model = viewModel.getMessageCellModel(for: indexPath.row) else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIdentifier,
                                                     for: indexPath) as! MessageCell
            cell.configure(
                with: model,
                delegate: self,
                onTapMessageIdButton: { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.didTapMessageIdButton(messageId: model.messageId)
                }
            )
            
            return cell
        case .loadingStatus:
            return tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! LoadingTableViewCell
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: FooterCell.reuseIdentifier,
                                                     for: indexPath) as! FooterCell
            cell.backButton
                .addTarget(viewModel, 
                           action: #selector(ThreadViewModel.handleBackButtonTap),
                           for: .touchUpInside)
            cell.topButton
                .addTarget(viewModel, 
                           action: #selector(ThreadViewModel.handleTopButtonTap),
                           for: .touchUpInside)
            cell.refreshButton
                .addTarget(viewModel, 
                           action: #selector(ThreadViewModel.handleRefreshButtonTap),
                           for: .touchUpInside)
            cell.createMessageButton
                .addTarget(viewModel, 
                           action: #selector(ThreadViewModel.handleCreateMessageButtonTap),
                           for: .touchUpInside)
        
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ThreadRootView: UITableViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let indexPath = lastSelectedRowIndexPath else {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? MessageCell {
            cell.select()
            lastSelectedRowIndexPath = nil
        }
    }
}

// MARK: - MessageCellDelegate
extension ThreadRootView: MessageCellDelegate {
    
    func didTapPhoto(_ photo: PhotoFile) {
        viewModel.didTapPhoto(photo)
    }
    
    func didSelectLink(_ link: CustomTextView.LinkType) {
        switch link {
        case .message(let id):
            viewModel.didTapReplyMessageIdButton(messageId: id)
        }
    }
    
    func didTapReplyMessageIdButton(messageId: Int) {
        viewModel.didTapReplyMessageIdButton(messageId: messageId)
    }
}

// MARK: - Layout
extension ThreadRootView {
    
    private func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
