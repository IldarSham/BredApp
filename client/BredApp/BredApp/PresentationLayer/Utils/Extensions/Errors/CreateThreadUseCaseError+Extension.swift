//
//  CreateThreadUseCaseError+Extension.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 10.04.2024.
//

import Foundation

extension CreateThreadUseCaseError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .attachmentsIsEmpty:
            return L.CreateThreadUseCaseError.attachmentsIsEmpty.localized
        }
    }
}
