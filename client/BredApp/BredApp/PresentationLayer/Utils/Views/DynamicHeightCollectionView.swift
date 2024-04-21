//
//  DynamicHeightCollectionView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 13.03.2024.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
