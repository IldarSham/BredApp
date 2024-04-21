//
//  CreateThreadViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 07.02.2024.
//

import UIKit
import Combine

class CreateThreadViewController: BaseCreateMessageViewController {
    
    // MARK: - Initialization
    
    init(viewModel: CreateThreadViewModel) {
        super.init(viewModel: viewModel)
    }
    
    // MARK: - Methods
    
    override func loadView() {
        self.view = CreateThreadRootView(viewModel: viewModel as! CreateThreadViewModel)
    }
}

protocol CreateThreadViewControllerFactory {
    
    func makeCreateThreadViewController(delegate: CreateThreadFlowDelegate) -> CreateThreadViewController
}
