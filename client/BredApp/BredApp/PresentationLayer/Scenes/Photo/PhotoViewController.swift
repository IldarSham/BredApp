//
//  PhotoViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 20.03.2024.
//

import UIKit
import Kingfisher

class PhotoViewController: NiblessViewController {
    
    // MARK: - Properties
    
    private let viewModel: PhotoViewModel
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.9)
        
        constructHierarchy()
        activateConstraints()
        setupGestures()
        
        imageView.kf.setImage(with: viewModel.photoURL)
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        self.view.addSubview(imageView)
    }
    
    private func activateConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }
}

protocol PhotoViewControllerFactory {
    
    func makePhotoViewController(photo: PhotoFile) -> PhotoViewController
}

// MARK: - Gesture
extension PhotoViewController {
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissScene))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissScene() {
        dismiss(animated: true)
    }
}
