//
//  PhotoCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 11.03.2024.
//

import UIKit
import Kingfisher

struct PhotoCellModel {
    let photo: PhotoFile
    let sizeInKB: String
}

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let photoDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS", size: 9)
        label.textColor = #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        return label
    }()
    
    private let photoImageView = UIImageView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with model: PhotoCellModel) {
        photoDetailsLabel.text = "\(model.sizeInKB) \(model.photo.width)x\(model.photo.height)"
        photoImageView.kf.setImage(with: model.photo.url)
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        contentView.addSubview(photoDetailsLabel)
        contentView.addSubview(photoImageView)
    }
    
    private func activateConstraints() {
        activateConstraintsphotoDetailsLabel()
        activateConstraintsPhotoImageView()
    }
    
    private func activateConstraintsphotoDetailsLabel() {
        photoDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoDetailsLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    private func activateConstraintsPhotoImageView() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: photoDetailsLabel.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: photoDetailsLabel.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: photoDetailsLabel.bottomAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
