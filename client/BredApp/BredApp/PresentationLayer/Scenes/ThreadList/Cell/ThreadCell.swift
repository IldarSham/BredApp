//
//  ThreadCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 06.02.2024.
//

import UIKit
import Kingfisher

struct ThreadCellModel {
    let previewPhoto: PhotoFile?
    let messagesCount: Int
    let filesCount: Int
    let title: String
    let contentPreview: String
}

class ThreadCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8765103221, green: 0.8765102625, blue: 0.8765103221, alpha: 1)
        view.layer.cornerRadius = 3.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9529411765, alpha: 1)
        return imageView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        return view
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PT Sans", size: 14)
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PT Sans Bold", size: 14)
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private let contentPreviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Verdana", size: 13)
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 5
        return label
    }()
    
    private var thumbnailImageViewSizeConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let constraint = self.thumbnailImageViewSizeConstraint {
            thumbnailImageView.removeConstraint(constraint)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with model: ThreadCellModel) {
        if let previewPhoto = model.previewPhoto {
            activateSizeConstraintsThumbnailImageView(width: CGFloat(previewPhoto.width),
                                                      height: CGFloat(previewPhoto.height))
            thumbnailImageView.kf.setImage(with: previewPhoto.url)
        }
        counterLabel.text = "\(L.ThreadListScreen.postsLabel.localized): \(model.messagesCount) / \(L.ThreadListScreen.filesLabel.localized): \(model.filesCount)"
        titleLabel.text = model.title
        contentPreviewLabel.text = model.contentPreview
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(headerView)
        headerView.addSubview(counterLabel)
        headerView.addSubview(titleLabel)
        containerView.addSubview(contentPreviewLabel)
    }
    
    private func activateConstraints() {
        activateConstraintsContainerView()
        activateConstraintsThumbnailImageView()
        activateConstraintsHeaderView()
        activateConstraintsCounterLabel()
        activateConstraintsThreadTitleLabel()
        activateConstraintsThreadPreviewLabel()
    }
}

// MARK: - Layout
extension ThreadCell {
    
    private func activateSizeConstraintsThumbnailImageView(width: CGFloat, height: CGFloat) {
        thumbnailImageViewSizeConstraint = thumbnailImageView.heightAnchor
            .constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: height / width)
        
        thumbnailImageViewSizeConstraint?.isActive = true
    }
    
    private func activateConstraintsContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    private func activateConstraintsThumbnailImageView() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 12),
            thumbnailImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 250).withPriority(750),
            thumbnailImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 250),
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
        ])
    }
    
    private func activateConstraintsHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 12),
            headerView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
    }

    private func activateConstraintsCounterLabel() {
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            counterLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5),
            counterLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -5),
            counterLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 3)
        ])
    }
    
    private func activateConstraintsThreadTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -5),
            titleLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -5)
        ])
    }

    private func activateConstraintsThreadPreviewLabel() {
        contentPreviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentPreviewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            contentPreviewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            contentPreviewLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            contentPreviewLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
}
