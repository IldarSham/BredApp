//
//  StartViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 01.01.2024.
//

import UIKit
import Combine

class StartViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: StartViewModel
    
    // State
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }

    override func loadView() {
        self.view = StartRootView(viewModel: viewModel)
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

protocol StartViewControllerFactory {
    
    func makeStartViewController(delegate: StartFlowDelegate) -> StartViewController
}
