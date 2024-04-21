//
//  PasswordTextField.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 04.01.2024.
//

import UIKit

class PasswordTextField: CustomTextField {
    
    // MARK: - Properties
    private lazy var toggleButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: .zero)
        rightViewMode = .always
        rightView = toggleButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        toggleButton.isSelected.toggle()
    }
}
