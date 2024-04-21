//
//  CustomActivityIndicator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.02.2024.
//

import UIKit

class CustomActivityIndicator: NiblessView {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 19)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    // MARK: - Initialization
    
    init(title: String = "Loading...") {
        super.init(frame: .zero)
        self.title = title
        self.backgroundColor = .black.withAlphaComponent(0.65)
        self.layer.cornerRadius = 6.0
        
        constructHierarchy()
        activateConstraints()
    }
    
    // MARK: - Public Methods
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        self.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        addSubview(titleLabel)
        addSubview(activityIndicator)
    }
    
    private func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsActivityIndicator()
    }
    
    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        ])
    }
    
    private func activateConstraintsActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}
