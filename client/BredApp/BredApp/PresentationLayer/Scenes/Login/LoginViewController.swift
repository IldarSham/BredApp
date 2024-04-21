//
//  LoginViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 07.10.2023.
//

import UIKit
import Combine

class LoginViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: LoginViewModel
    
    // State
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - Methods
    override func loadView() {
        self.view = LoginRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
        setupGestures()
    }
    
    // MARK: - Private Methods
    private func observeViewModel() {
        viewModel.errorMessages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                guard let self = self else { return }
                self.presentAlert(title: alert.title, message: alert.message)
            }
            .store(in: &subscriptions)
        
        viewModel.$activityIndicatorAnimating
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dismissKeyboard()
            }
            .store(in: &subscriptions)
    }
}

protocol LoginViewControllerFactory {
    
    func makeLoginViewController(delegate: LoginFlowDelegate) -> LoginViewController
}

extension LoginViewController {
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
