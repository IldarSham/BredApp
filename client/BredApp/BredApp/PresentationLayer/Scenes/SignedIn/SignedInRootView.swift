//
//  SignedInRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 05.02.2024.
//

import UIKit
import Combine

class SignedInRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: SignedInViewModel
    var subscriptions = Set<AnyCancellable>()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .orange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init(viewModel: SignedInViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = .white
        bindViewModelToViews()
        constructHierarchy()
        activateConstraints()
        showThreadListScene()
    }
    
    // MARK: - Private Methods
    private func bindViewModelToViews() {
        bindActivityIndicator()
    }
    
    private func constructHierarchy() {
        addSubview(activityIndicator)
    }
    
    private func activateConstraints() {
        activateConstraintsActivityIndicator()
    }
    
    private func showThreadListScene() {
        viewModel.showThreadListScene()
    }
}

// MARK: - Binding
extension SignedInRootView {
    
    private func bindActivityIndicator() {
        viewModel
            .$activityIndicatorAnimating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] animating in
                switch animating {
                case true: self?.activityIndicator.startAnimating()
                case false: self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Layout
extension SignedInRootView {
    
    private func activateConstraintsActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
