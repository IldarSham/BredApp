//
//  CreateMessageRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 02.04.2024.
//

import UIKit

class CreateMessageRootView: BaseCreateMessageRootView {
    
    // MARK: - Initialization
    
    init(viewModel: CreateMessageViewModel) {
        super.init(viewModel: viewModel)
        configureViews()
    }
    
    // MARK: - Private Methods
    
    private func configureViews() {
        messageTextView.text = (viewModel as! CreateMessageViewModel).initialText
    }
}
