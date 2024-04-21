//
//  ThreadListViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 04.02.2024.
//

import UIKit
import Combine

class ThreadListViewController: NiblessViewController {
    
    // MARK: - Properties
    
    let viewModel: ThreadListViewModel
    
    // State
    var subscriptions = Set<AnyCancellable>()
    
    lazy var settingsBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: viewModel,
            action: #selector(ThreadListViewModel.handleSettingsButtonTap)
        )
        item.tintColor = .darkGray
        return item
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ThreadListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        observeViewModel()
    }
    
    override func loadView() {
        self.view = ThreadListRootView(viewModel: viewModel)
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationItem() {
        self.navigationItem.title = L.ThreadListScreen.navigationItemTitle.localized
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    private func observeViewModel() {
        viewModel.errorMessages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                guard let self = self else { return }
                self.presentAlert(title: alert.title, message: alert.message)
            }
            .store(in: &subscriptions)
    }
}

protocol ThreadListViewControllerFactory {
    
    func makeThreadListViewController(delegate: ThreadListFlowDelegate) -> ThreadListViewController
}
