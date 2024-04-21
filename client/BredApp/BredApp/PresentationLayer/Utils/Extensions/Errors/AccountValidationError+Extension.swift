//
//  AccountValidationError+Extension.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.02.2024.
//

import Foundation

extension AccountValidator.ValidationError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .usernameIsEmpty:
            return L.ValidationError.usernameIsEmpty.localized
        case .emailIsEmpty:
            return L.ValidationError.emailIsEmpty.localized
        case .passwordIsEmpty:
            return L.ValidationError.passwordIsEmpty.localized
        case .invalidEmailFormat:
            return L.ValidationError.invalidEmailFormat.localized
        case .invalidPasswordLength:
            return L.ValidationError.invalidPasswordLength.localized
        case .passwordsDoNotMatch:
            return L.ValidationError.passwordsDoNotMatch.localized
        }
    }
}
