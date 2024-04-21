//
//  PhotoCollectionView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 15.03.2024.
//

import UIKit

protocol PhotoCollectionViewDelegate: AnyObject {
    func didTapPhoto(_ photo: PhotoFile)
}

class PhotoCollectionView: DynamicHeightCollectionView {
    
    // MARK: - Properties
    
    weak var customDelegate: PhotoCollectionViewDelegate?
    
    private var data: [PhotoCellModel] = []
    
    // MARK: - Initialization
    
    init() {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        super.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        dataSource = self
        delegate = self
        register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setData(_ data: [PhotoCellModel]) {
        self.data = data
        self.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        cell.configure(with: data[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customDelegate?.didTapPhoto(data[indexPath.item].photo)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = data[indexPath.item].photo
        
        let width = min(Constants.maxPhotoWidth, Constants.maxPhotoHeight * photo.width / photo.height)
        let height = min(Constants.maxPhotoHeight, Constants.maxPhotoWidth * photo.height / photo.width) 
            + Constants.detailsLabelHeight
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - Constants
extension PhotoCollectionView {
    
    enum Constants {
        static let detailsLabelHeight = 10
        static let maxPhotoWidth = 110
        static let maxPhotoHeight = 160
        static let minimumLineSpacing: CGFloat = 1.0
        static let minimumInteritemSpacing: CGFloat = 1.0
    }
}
