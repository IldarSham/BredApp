//
//  NewAccountValidator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 31.01.2024.
//

import Foundation

protocol AccountValidatorProtocol {
    func validateUsername(_ username: String) throws
    func validateEmail(_ email: String) throws
    func validatePassword(_ password: String) throws
    func validateConfirmPassword(_ confirmPassword: String, password: String) throws
}

class AccountValidator: AccountValidatorProtocol {
    
    // MARK: - Methods
    func validateUsername(_ username: String) throws {
        guard !username.isEmpty else {
            throw ValidationError.usernameIsEmpty
        }
    }
    
    func validateEmail(_ email: String) throws {
        guard !email.isEmpty else {
            throw ValidationError.emailIsEmpty
        }
        
        guard isValidEmail(email) else {
            throw ValidationError.invalidEmailFormat
        }
    }
    
    func validatePassword(_ password: String) throws {
        guard !password.isEmpty else {
            throw ValidationError.passwordIsEmpty
        }
        
        guard password.count >= Constants.passwordRequiredLength else {
            throw ValidationError.invalidPasswordLength
        }
    }
    
    func validateConfirmPassword(_ confirmPassword: String, password: String) throws {
        guard password == confirmPassword else {
            throw ValidationError.passwordsDoNotMatch
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        if #available(iOS 16.0, *) {
            let emailRegex = #/^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/#
            return email.contains(emailRegex)
        } else {
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailTest.evaluate(with: email)
        }
    }
}

// MARK: - Errors
extension AccountValidator {
    
    enum ValidationError: Error {
        case usernameIsEmpty
        case emailIsEmpty
        case passwordIsEmpty
        case invalidEmailFormat
        case invalidPasswordLength
        case passwordsDoNotMatch
    }
}

// MARK: - Constants
extension AccountValidator {
    
    enum Constants {
        static let passwordRequiredLength = 6
    }
}
