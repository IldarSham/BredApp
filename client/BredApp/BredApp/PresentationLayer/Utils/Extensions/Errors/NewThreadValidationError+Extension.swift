//
//  NewThreadValidationError+Extension.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 10.04.2024.
//

import Foundation

extension NewThreadValidator.ValidationError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .titleIsEmpty:
            return L.ValidationError.threadTitleIsEmpty.localized
        case .contentIsEmpty:
            return L.ValidationError.contentIsEmpty.localized
        }
    }
}
