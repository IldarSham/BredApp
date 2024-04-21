//
//  ThreadViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.02.2024.
//

import Foundation
import Combine
import UIKit

class ThreadViewController: NiblessViewController {
    
    // MARK: - Properties
    
    private let viewModel: ThreadViewModel
    private let createThreadViewControllerFactory: CreateThreadViewControllerFactory
    
    // State
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(viewModel: ThreadViewModel, createThreadViewControllerFactory: CreateThreadViewControllerFactory) {
        self.viewModel = viewModel
        self.createThreadViewControllerFactory = createThreadViewControllerFactory
        super.init()
    }

    // MARK: - Public Methods
    
    override func loadView() {
        self.view = ThreadRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }
    
    // MARK: - Private Methods
    
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

protocol ThreadViewControllerFactory {
    
    func makeThreadViewController(threadId: Int, delegate: ThreadFlowDelegate) -> ThreadViewController
}
