//
//  RemoteAPIManagerError+Extension.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 04.02.2024.
//

import Foundation

extension RemoteAPIManagerError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return L.RemoteAPIManagerError.unauthorized.localized
        default:
            return nil
        }
    }
}
