//
//  ThreadListRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 05.02.2024.
//

import UIKit
import Combine

class ThreadListRootView: NiblessView {
    
    enum TableSection: Int, CaseIterable {
        case createThread
        case threadsList
        case loadingStatus
    }
    
    // MARK: - Properties
    
    let viewModel: ThreadListViewModel
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(CreateThreadCell.self, forCellReuseIdentifier: CreateThreadCell.reuseIdentifier)
        tableView.register(ThreadCell.self, forCellReuseIdentifier: ThreadCell.reuseIdentifier)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .orange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ThreadListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        bindViewModelToViews()
        constructHierarchy()
        activateConstraints()
        loadThreadList()
    }
    
    // MARK: - Public Methods
    
    @objc
    func refresh() {
        viewModel.refreshThreadList()
    }
    
    // MARK: - Private Methods
    
    private func bindViewModelToViews() {
        bindTableViewReloadData()
        bindTableViewLoadingStatus()
    }
    
    private func constructHierarchy() {
        addSubview(tableView)
        addSubview(activityIndicator)
    }
    
    private func activateConstraints() {
        activateConstraintsTableView()
    }
    
    private func loadThreadList() {
        viewModel.loadThreadList()
    }
}

// MARK: - UITableViewDataSource
extension ThreadListRootView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = TableSection(rawValue: section)
        switch section {
        case .createThread:
            return 1
        case .threadsList:
            return viewModel.threadsCount()
        case .loadingStatus where viewModel.isLoadingInProgress:
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
        case .createThread:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateThreadCell.reuseIdentifier,
                                                     for: indexPath) as! CreateThreadCell
            cell.selectionStyle = .none
            
            cell.createThreadButton.addTarget(
                viewModel,
                action: #selector(ThreadListViewModel.createThread),
                for: .touchUpInside)
            
            return cell
        case .threadsList:
            let cell = tableView.dequeueReusableCell(withIdentifier: ThreadCell.reuseIdentifier,
                                                     for: indexPath) as! ThreadCell
            cell.selectionStyle = .none
            
            let model = viewModel.getThreadCellModel(for: indexPath.row)
            cell.configure(with: model)
            
            return cell
        case .loadingStatus:
            return tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier,
                                                 for: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension ThreadListRootView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = TableSection(rawValue: indexPath.section)
        
        if section == .threadsList {
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.didSelectRowAt(index: indexPath.row)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ThreadListRootView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        
        if currentOffset >= maximumOffset {
            viewModel.loadThreadList()
        }
    }
}

// MARK: - Binding
extension ThreadListRootView {
    
    private func bindTableViewReloadData() {
        viewModel
            .reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel
            .reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &subscriptions)
    }
    
    private func bindTableViewLoadingStatus() {
        viewModel
            .$isLoadingInProgress
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.tableView.reloadSections(IndexSet(integer: TableSection.loadingStatus.rawValue), with: .none)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Layout
extension ThreadListRootView {
    
    private func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
