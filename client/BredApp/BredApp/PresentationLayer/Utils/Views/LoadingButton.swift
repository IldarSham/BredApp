//
//  LoadingButton.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 26.03.2024.
//

import UIKit

class LoadingButton: UIButton {
    
    // MARK: - Properties
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func startAnimating() {
        titleLabel?.alpha = 0.0
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        titleLabel?.alpha = 1.0
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        addSubview(activityIndicator)
    }
    
    private func activateConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
