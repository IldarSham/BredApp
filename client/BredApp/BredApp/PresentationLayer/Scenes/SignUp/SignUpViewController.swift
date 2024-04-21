//
//  SignUpViewController.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.12.2023.
//

import UIKit
import Combine

class SignUpViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: SignUpViewModel
    
    // State
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Public Methods
    override func loadView() {
        self.view = SignUpRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
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

protocol SignUpViewControllerFactory {
    func makeSignUpViewController(delegate: SignUpFlowDelegate) -> SignUpViewController
}

extension SignUpViewController {
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension SignUpViewController {
    
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo, 
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                (view as! SignUpRootView).moveContentForDismissedKeyboard()
            } else {
                (view as! SignUpRootView).moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }
}
