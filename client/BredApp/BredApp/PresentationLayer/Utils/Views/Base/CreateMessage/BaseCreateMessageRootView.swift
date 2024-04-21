//
//  CreateMessageRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 21.03.2024.
//

import UIKit
import Combine

class BaseCreateMessageRootView: NiblessView {
    
    // MARK: - Properties
    
    let viewModel: BaseCreateMessageViewModel
    var subscriptions = Set<AnyCancellable>()
    
    private(set) lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [contentInputStack])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var contentInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageLabel, messageTextView])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private let messageLabel: UILabel = {
        let label = InsetLabel(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        label.font = UIFont(name: "PT Sans", size: 15)
        label.text = L.CreateMessageScreen.messageLabel.localized
        label.textColor = .darkGray
        return label
    }()
    
    private(set) var messageTextView: UITextView = {
        let textView = ContentTextView()
        textView.heightAnchor
            .constraint(equalToConstant: 200)
            .isActive = true
        return textView
    }()
    
    private let addAttachmentsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(L.CreateMessageScreen.addAttachmentsButton.localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 11.25
        button.backgroundColor = .orange.withAlphaComponent(0.75)
        return button
    }()
    
    private lazy var photosPreviewCollectionView: UICollectionView = {
        let collectionView = PhotosPreviewCollectionView()
        collectionView.dataSource = self
        return collectionView
    }()
    
    private(set) var activityIndicator = CustomActivityIndicator(title: L.CreateMessageScreen.activityIndicatorTitle.localized)
    
    // MARK: - Initialization
    
    init(viewModel: BaseCreateMessageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        
        bindViewModelToViews()
        constructHierarchy()
        activateConstraints()
        addTargets()
    }
    
    func bindViewModelToViews() {
        bindViewModelToMessageTextView()
        bindViewModelToActivityIndicator()
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        addSubview(inputStack)
        addSubview(addAttachmentsButton)
        addSubview(photosPreviewCollectionView)
        addSubview(activityIndicator)
    }
    
    private func activateConstraints() {
        activateConstraintsInputStack()
        activateConstraintsAddAttachmentsButton()
        activateConstraintsPhotosPreviewCollectionView()
        activateConstraintsActivityIndicator()
    }
    
    private func addTargets() {
        addAttachmentsButton.addTarget(viewModel,
                                       action: #selector(BaseCreateMessageViewModel.addAttachments),
                                       for: .touchUpInside)
    }
}

// MARK: - Binding
extension BaseCreateMessageRootView {
    
    private func bindViewModelToMessageTextView() {
        messageTextView
            .textPublisher
            .assign(to: \.messageText, on: viewModel)
            .store(in: &subscriptions)
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
}

// MARK: - Public Methods
extension BaseCreateMessageRootView {
    
    func insertPhotoAttachment(photo: UIImage) {
        let numberOfItems = photosPreviewCollectionView.numberOfItems(inSection: 0)
        let indexPath = IndexPath(item: numberOfItems,
                                  section: 0)
        viewModel.insertPhotoAttachment(photo: photo)
        photosPreviewCollectionView.insertItems(at: [indexPath])
    }
    
    func deletePhotoAttachment(cell: PhotoPreviewCell) {
        guard let indexPath = photosPreviewCollectionView.indexPath(for: cell) else {
            return
        }
        viewModel.deletePhotoAttachment(at: indexPath.item)
        photosPreviewCollectionView.deleteItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDataSource
extension BaseCreateMessageRootView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPreviewCell.reuseIdentifier, for: indexPath) as! PhotoPreviewCell
        
        guard let model = viewModel.getPhotoPreviewCellModel(for: indexPath.item) else {
            return UICollectionViewCell()
        }
        cell.configure(
            model: model,
            onTapRemovePhotoButton: { [weak self] in
                guard let self = self else { return }
                self.deletePhotoAttachment(cell: cell)
            }
        )
        
        return cell
    }
}

// MARK: - Layout
extension BaseCreateMessageRootView {
    
    func activateConstraintsInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            inputStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            inputStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
    
    private func activateConstraintsAddAttachmentsButton() {
        addAttachmentsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addAttachmentsButton.leadingAnchor.constraint(equalTo: inputStack.leadingAnchor),
            addAttachmentsButton.trailingAnchor.constraint(equalTo: inputStack.trailingAnchor),
            addAttachmentsButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor, constant: 15),
            addAttachmentsButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func activateConstraintsPhotosPreviewCollectionView() {
        photosPreviewCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photosPreviewCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photosPreviewCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photosPreviewCollectionView.topAnchor.constraint(equalTo: addAttachmentsButton.bottomAnchor, constant: 20),
            photosPreviewCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func activateConstraintsActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
