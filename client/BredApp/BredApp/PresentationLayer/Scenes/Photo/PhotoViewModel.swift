//
//  PhotoViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 20.03.2024.
//

import Foundation

class PhotoViewModel {
    
    // MARK: - Properties
    
    private let photo: PhotoFile
    
    var photoURL: URL {
        return photo.url
    }
    
    // MARK: - Initialization
    
    init(photo: PhotoFile) {
        self.photo = photo
    }
}
