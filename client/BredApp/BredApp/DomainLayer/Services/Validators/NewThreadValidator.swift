//
//  NewThread.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.02.2024.
//

import Foundation

protocol NewThreadValidatorProtocol {
    func validateTitle(_ title: String) throws
    func validateContent(_ content: String) throws
}

class NewThreadValidator: NewThreadValidatorProtocol {
    
    func validateTitle(_ title: String) throws {
        guard !title.isEmpty else {
            throw ValidationError.titleIsEmpty
        }
    }
    
    func validateContent(_ content: String) throws {
        guard !content.isEmpty else {
            throw ValidationError.contentIsEmpty
        }
    }
}

// MARK: - Errors
extension NewThreadValidator {
    
    enum ValidationError: Error {
        case titleIsEmpty
        case contentIsEmpty
    }
}
