//
//  LoadingTableViewCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 28.02.2024.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .orange
        indicator.hidesWhenStopped = false
        return indicator
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        constructHierarchy()
        activateConstraints()
        
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        contentView.addSubview(activityIndicator)
    }
    
    private func activateConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
