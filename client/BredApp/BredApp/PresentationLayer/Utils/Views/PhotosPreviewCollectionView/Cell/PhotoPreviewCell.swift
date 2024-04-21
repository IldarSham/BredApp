//
//  PhotoPreviewCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 11.02.2024.
//

import UIKit

struct PhotoPreviewCellModel {
    let image: UIImage
    let sizeInMB: String
}

class PhotoPreviewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var didTapRemovePhotoButton: (() -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let imageSizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS Bold", size: 13)
        label.textColor = .black.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var removePhotoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.black.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(removePhoto), for: .touchUpInside)
        return button
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8926360607, green: 0.8926360011, blue: 0.8926360011, alpha: 1)
        view.alpha = 0.8
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    @objc
    private func removePhoto() {
        didTapRemovePhotoButton?()
    }
    
    private func constructHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(bottomView)
        bottomView.addSubview(imageSizeLabel)
        bottomView.addSubview(removePhotoButton)
    }
    
    private func activateConstraints() {
        activateConstraintsImageView()
        activateConstraintsBottomView()
        activateConstraintsImageSizeLabel()
        activateConstraintsRemovePhotoButton()
    }
}

// MARK: - Public Methods
extension PhotoPreviewCell {

    func configure(model: PhotoPreviewCellModel, onTapRemovePhotoButton: @escaping () -> Void) {
        imageView.image = model.image
        imageSizeLabel.text = model.sizeInMB
        didTapRemovePhotoButton = onTapRemovePhotoButton
    }
}

// MARK: - Layout
extension PhotoPreviewCell {
    
    func activateConstraintsImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func activateConstraintsBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 23)
        ])
    }
    
    func activateConstraintsImageSizeLabel() {
        imageSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageSizeLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 2),
            imageSizeLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            imageSizeLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
    }
    
    func activateConstraintsRemovePhotoButton() {
        removePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removePhotoButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            removePhotoButton.widthAnchor.constraint(equalToConstant: 30),
            removePhotoButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2),
            removePhotoButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -2),
        ])
    }
}
