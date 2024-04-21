//
//  SignedInViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 04.02.2024.
//

import UIKit

class SignedInViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: SignedInViewModel
    
    // MARK: - Methods
    init(viewModel: SignedInViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = SignedInRootView(viewModel: viewModel)
    }
}

protocol SignedInViewControllerFactory {
    
    func makeSignedInViewController(delegate: SignedInFlowDelegate) -> SignedInViewController
}
