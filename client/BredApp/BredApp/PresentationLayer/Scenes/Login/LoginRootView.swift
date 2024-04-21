//
//  LoginRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 20.12.2023.
//

import UIKit
import Combine

class LoginRootView: NiblessView {
    
    // MARK: - Properties
    private let viewModel: LoginViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "/b/"
        label.textColor = .systemOrange
        label.font = UIFont(name: "Chalkboard SE", size: 90)
        return label
    }()
    
    private lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameInputStack, passwordInputStack])
        stack.axis = .vertical
        stack.spacing = 30
        return stack
    }()
    
    private lazy var usernameInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameIcon, usernameField])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 15
        return stack
    }()
    
    private let usernameIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.widthAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.heightAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.tintColor = .systemOrange
        return imageView
    }()
    
    private let usernameField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = L.Base.usernameField.localized
        field.textContentType = .username
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var passwordInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordIcon, passwordField])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 15
        return stack
    }()
    
    private let passwordIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lock.circle"))
        imageView.widthAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.heightAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.tintColor = .systemOrange
        return imageView
    }()
    
    private let passwordField: PasswordTextField = {
        let field = PasswordTextField()
        field.placeholder = L.SignInScreen.passwordField.localized
        field.isSecureTextEntry = true
        field.textContentType = .password
        return field
    }()
    
    private let loginButton: LoadingButton = {
        let button = LoadingButton()
        button.setTitle(L.SignInScreen.loginButton.localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 15
        button.backgroundColor = .orange
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(L.Base.signUpButton.localized, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Initialization
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        bindFieldsToViewModel()
        constructHierarchy()
        activateConstraints()
        addTargets()
    }
    
    // MARK: - Private Methods
    private func constructHierarchy() {
        addSubview(logoLabel)
        addSubview(inputStack)
        addSubview(loginButton)
        addSubview(signUpButton)
    }
    
    private func activateConstraints() {
        activateConstraintsLogoLabel()
        activateConstraintsInputStack()
        activateConstraintsSignInButton()
        activateConstraintsSignUpButton()
    }
    
    private func bindFieldsToViewModel() {
        bindUsernameField()
        bindPasswordField()
        bindActivityIndicator()
    }
    
    private func addTargets() {
        loginButton
            .addTarget(viewModel, action: #selector(LoginViewModel.signIn), for: .touchUpInside)
        signUpButton
            .addTarget(viewModel, action: #selector(LoginViewModel.signUp), for: .touchUpInside)
    }
}

// MARK: - Binding
extension LoginRootView {
    
    private func bindUsernameField() {
        usernameField
            .textPublisher
            .assign(to: \.username, on: viewModel)
            .store(in: &subscriptions)
    }
    
    private func bindPasswordField() {
        passwordField
            .textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
    }
    
    private func bindActivityIndicator() {
        viewModel
            .$activityIndicatorAnimating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] animating in
                switch animating {
                case true: self?.loginButton.startAnimating()
                case false: self?.loginButton.stopAnimating()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Layout
extension LoginRootView {
    
    private func activateConstraintsLogoLabel() {
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }
    
    private func activateConstraintsInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            inputStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            inputStack.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 15)
        ])
    }
    
    private func activateConstraintsSignInButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            loginButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor, constant: 35),
            loginButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func activateConstraintsSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            signUpButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
