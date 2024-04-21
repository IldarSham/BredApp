//
//  SignUpRootView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.12.2023.
//

import UIKit
import Combine

class SignUpRootView: NiblessView {

    // MARK: - Properties
    
    let viewModel: SignUpViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L.SignUpScreen.titleLabel.localized
        label.font = UIFont.boldSystemFont(ofSize: 35)
        return label
    }()
    
    private lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameInputStack, emailInputStack, passwordInputStack, confirmPasswordInputStack])
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
        imageView.tintColor = .orange
        return imageView
    }()
    
    private let usernameField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = L.Base.usernameField.localized
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var emailInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailIcon, emailField])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 15
        return stack
    }()
    
    private let emailIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "envelope"))
        imageView.widthAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.heightAnchor
            .constraint(equalToConstant: 30)
            .isActive = true
        imageView.tintColor = .orange
        return imageView
    }()
    
    private let emailField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = "E-mail"
        field.keyboardType = .emailAddress
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
        imageView.tintColor = .orange
        return imageView
    }()
    
    private let passwordField: PasswordTextField = {
        let field = PasswordTextField()
        field.placeholder = L.SignInScreen.passwordField.localized
        field.isSecureTextEntry = true
        field.textContentType = .password
        field.textContentType = .oneTimeCode
        return field
    }()
    
    private lazy var confirmPasswordInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [confirmPasswordIcon, confirmPasswordField])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 15
        return stack
    }()
    
    private let confirmPasswordIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lock.circle"))
        imageView.widthAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.heightAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.tintColor = .orange
        return imageView
    }()
    
    private let confirmPasswordField: PasswordTextField = {
        let field = PasswordTextField()
        field.placeholder = L.SignUpScreen.confirmPasswordField.localized
        field.isSecureTextEntry = true
        field.textContentType = .password
        field.textContentType = .oneTimeCode
        return field
    }()
    
    private let signUpButton: LoadingButton = {
        let button = LoadingButton()
        button.setTitle(L.Base.signUpButton.localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 15
        button.backgroundColor = .orange
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(L.SignUpScreen.alreadyHaveAccountButton.localized, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Initialization
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        
        bindFieldsToViewModel()
        constructHierarchy()
        activateConstraints()
        addTargets()
    }
    
    // MARK: - Private Methods
    
    private func bindFieldsToViewModel() {
        bindUsernameField()
        bindEmailField()
        bindPasswordField()
        bindConfirmPasswordField()
        bindActivityIndicator()
    }
    
    private func constructHierarchy() {
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(inputStack)
        contentView.addSubview(signUpButton)
        contentView.addSubview(alreadyHaveAccountButton)
        addSubview(scrollView)
    }
    
    private func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsTitleLabel()
        activateConstraintsInputStack()
        activateConstraintsSignUpButton()
        activateConstraintsAlreadyHaveAccountButton()
    }
    
    private func addTargets() {
        signUpButton
            .addTarget(viewModel, action: #selector(SignUpViewModel.signUp), for: .touchUpInside)
        alreadyHaveAccountButton
            .addTarget(viewModel, action: #selector(SignUpViewModel.alreadyHaveAccount), for: .touchUpInside)
    }
}

// MARK: - Binding
extension SignUpRootView {
    
    private func bindUsernameField() {
        usernameField
            .textPublisher
            .assign(to: \.username, on: viewModel)
            .store(in: &subscriptions)
    }
    
    private func bindEmailField() {
        emailField
            .textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)
    }
    
    private func bindPasswordField() {
        passwordField
            .textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: &subscriptions)
    }
    
    private func bindConfirmPasswordField() {
        confirmPasswordField
            .textPublisher
            .assign(to: \.confirmPassword, on: viewModel)
            .store(in: &subscriptions)
    }
    
    private func bindActivityIndicator() {
        viewModel
            .$activityIndicatorAnimating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] animating in
                switch animating {
                case true: self?.signUpButton.startAnimating()
                case false: self?.signUpButton.stopAnimating()
                }
            }.store(in: &subscriptions)
    }
}

// MARK: - Layout
extension SignUpRootView {
    
    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
            
        let frameLayoutGuide = scrollView.frameLayoutGuide
        NSLayoutConstraint.activate([
            frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameLayoutGuide.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLayoutGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ])
    }
    
    private func activateConstraintsInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            inputStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            inputStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
    }
    
    private func activateConstraintsSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: inputStack.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: inputStack.trailingAnchor),
            signUpButton.topAnchor.constraint(equalTo: inputStack.bottomAnchor, constant: 35),
            signUpButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func activateConstraintsAlreadyHaveAccountButton() {
        alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alreadyHaveAccountButton.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor),
            alreadyHaveAccountButton.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor),
            alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            alreadyHaveAccountButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

extension SignUpRootView {
    
    func moveContentForDismissedKeyboard() {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        var insets = scrollView.contentInset
        insets.bottom = keyboardFrame.height
        scrollView.contentInset = insets
    }
}
