//
//  StringsEnum.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 22.12.2023.
//

import Foundation

protocol LocalizationEnumProtocol {
    var localized: String { get }
}

extension LocalizationEnumProtocol where Self: RawRepresentable {
    
    var localized: String {
        "\(Self.self)_\(self.rawValue)".localized()
    }
}

typealias L = Localization

enum Localization {
    
    enum Base: String, LocalizationEnumProtocol {
        case usernameField
        case signUpButton
    }
    
    enum ErrorMessage: String, LocalizationEnumProtocol {
        case title
    }
    
    enum SignUpScreen: String, LocalizationEnumProtocol {
        case titleLabel
        case confirmPasswordField
        case alreadyHaveAccountButton
    }
    
    enum SignInScreen: String, LocalizationEnumProtocol {
        case passwordField
        case loginButton
    }
    
    enum ThreadListScreen: String, LocalizationEnumProtocol {
        case navigationItemTitle
        case createThreadButton
        case postsLabel
        case filesLabel
    }
    
    enum ThreadScreen: String, LocalizationEnumProtocol {
        case createMessageButton
        case backButton
        case topButton
        case refreshButton
    }
    
    enum SettingsScreen: String, LocalizationEnumProtocol {
        case navigationItemTitle
        case signOutRow
    }
    
    enum CreateMessageScreen: String, LocalizationEnumProtocol {
        case closeBarButton
        case sendBarButton
        case messageLabel
        case addAttachmentsButton
        case activityIndicatorTitle
    }
    
    enum CreateThreadScreen: String, LocalizationEnumProtocol {
        case titleLabel
        case activityIndicatorTitle
    }
    
    enum CreateThreadUseCaseError: String, LocalizationEnumProtocol {
        case attachmentsIsEmpty
    }
    
    enum ValidationError: String, LocalizationEnumProtocol {
        case usernameIsEmpty
        case emailIsEmpty
        case passwordIsEmpty
        case invalidEmailFormat
        case invalidPasswordLength
        case passwordsDoNotMatch
        case contentIsEmpty
        case threadTitleIsEmpty
    }
    
    enum RemoteAPIManagerError: String, LocalizationEnumProtocol {
        case unauthorized
    }
}
