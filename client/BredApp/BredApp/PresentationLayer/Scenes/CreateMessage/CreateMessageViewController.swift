//
//  CreateMessageViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 21.03.2024.
//

import UIKit
import Combine

class CreateMessageViewController: BaseCreateMessageViewController {
    
    // MARK: - Initialization
    
    init(viewModel: CreateMessageViewModel) {
        super.init(viewModel: viewModel)
    }

    // MARK: - Public Methods

    override func loadView() {
        self.view = CreateMessageRootView(viewModel: viewModel as! CreateMessageViewModel)
    }
}

protocol CreateMessageViewControllerFactory {
    
    func makeCreateMessageViewController(threadId: Int, 
                                         initialText: String?,
                                         delegate: CreateMessageFlowDelegate) -> CreateMessageViewController
}
