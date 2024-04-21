//
//  StartRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 11.01.2024.
//

import UIKit
import Combine

class StartRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: StartViewModel
    var subscriptions = Set<AnyCancellable>()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .orange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        bindViewModelToViews()
        loadUserSession()
    }
    
    private func constructHierarchy() {
        addSubview(activityIndicator)
    }
    
    private func activateConstraints() {
        activateConstraintsActivityIndicator()
    }
    
    private func bindViewModelToViews() {
        bindViewModelToActivityIndicator()
    }
    
    private func bindViewModelToActivityIndicator() {
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
    
    private func loadUserSession() {
        viewModel.loadUserSession()
    }
}

// MARK: - Layout
extension StartRootView {
    
    private func activateConstraintsActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
