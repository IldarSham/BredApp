//
//  SignedInViewModel.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 05.02.2024.
//

import Foundation

protocol SignedInFlowDelegate {
    func didSignInAndNavigateToThreadList()
}

class SignedInViewModel {
    
    // MARK: - Properties
    
    private let delegate: SignedInFlowDelegate
    
    @Published private(set) var activityIndicatorAnimating = true
    
    // MARK: - Initialization
    
    init(delegate: SignedInFlowDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    func showThreadListScene() {
        delegate.didSignInAndNavigateToThreadList()
    }
}
