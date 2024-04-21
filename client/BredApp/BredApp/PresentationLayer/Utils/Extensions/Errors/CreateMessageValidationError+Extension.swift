//
//  CreateMessageValidationError+Extension.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 12.04.2024.
//

import Foundation

extension CreateMessageUseCaseError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .contentIsEmpty:
            return L.ValidationError.contentIsEmpty.localized
        }
    }
}
