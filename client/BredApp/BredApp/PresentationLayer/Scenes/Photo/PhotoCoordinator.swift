//
//  PhotoCoordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 20.03.2024.
//

import Foundation

class PhotoCoordinator: Coordinator {
    
    // MARK: Properties
    let router: Router
    
    // Input data
    let photo: PhotoFile
    
    // Factories
    let photoViewControllerFactory: PhotoViewControllerFactory
    
    // MARK: - Initialization
    init(photo: PhotoFile,
         router: Router,
         photoViewControllerFactory: PhotoViewControllerFactory) {
        self.photo = photo
        self.router = router
        self.photoViewControllerFactory = photoViewControllerFactory
    }
    
    // MARK: - Methods
    func start() {
        let viewController = photoViewControllerFactory.makePhotoViewController(photo: photo)
        router.present(viewController,
                       presentationStyle: .overCurrentContext,
                       transitionStyle: .crossDissolve)
    }
}

protocol PhotoCoordinatorFactory {
    
    func makePhotoCoordinator(photo: PhotoFile, router: Router) -> Coordinator
}
