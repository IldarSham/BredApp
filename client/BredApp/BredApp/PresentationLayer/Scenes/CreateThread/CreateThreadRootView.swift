//
//  CreateThreadRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 07.02.2024.
//

import UIKit
import Combine

class CreateThreadRootView: BaseCreateMessageRootView {
    
    // MARK: - Properties
    
    private lazy var titleInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = InsetLabel(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        label.font = UIFont(name: "PT Sans", size: 15)
        label.text = L.CreateThreadScreen.titleLabel.localized
        label.textColor = .darkGray
        return label
    }()
    
    private let titleTextField = TitleTextField()

    // MARK: - Initialization
    
    init(viewModel: CreateThreadViewModel) {
        super.init(viewModel: viewModel)
        constructHierarchy()
        configureViews()
        bindViewModelToViews()
    }
    
    // MARK: - Public Methods
    
    override func bindViewModelToViews() {
        super.bindViewModelToViews()
        bindViewModelToTitleTextField()
    }

    // MARK: - Private Methods
    
    private func constructHierarchy() {
        inputStack.insertArrangedSubview(titleInputStack, at: 0)
    }
    
    private func configureViews() {
        activityIndicator.title = L.CreateThreadScreen.activityIndicatorTitle.localized
    }
}

// MARK: - Binding
extension CreateThreadRootView {
    
    func bindViewModelToTitleTextField() {
        titleTextField
            .textPublisher
            .assign(to: \.titleText, on: viewModel as! CreateThreadViewModel)
            .store(in: &subscriptions)
    }
}
