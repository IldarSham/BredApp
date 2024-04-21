//
//  PhotoPreviewCollectionView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 11.02.2024.
//

import UIKit

class PhotosPreviewCollectionView: UICollectionView {

    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        super.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 0, left: Constants.contentInset, bottom: Constants.contentInset, right: Constants.contentInset)
        delegate = self
        register(PhotoPreviewCell.self, forCellWithReuseIdentifier: PhotoPreviewCell.reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosPreviewCollectionView: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.contentInset * 2 + Constants.minimumInteritemSpacing * (Constants.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = floor(availableWidth / Constants.itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

// MARK: - Constants
extension PhotosPreviewCollectionView {
    
    private enum Constants {
        static let itemsPerRow: CGFloat = 3
        static let minimumLineSpacing: CGFloat = 10.0
        static let minimumInteritemSpacing: CGFloat = 10.0
        static let contentInset: CGFloat = 10.0
    }
}
