//
//  ThreadByIdRequest.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.02.2024.
//

import Foundation

struct ThreadByIdRequest {
    let threadId: Int
}

// MARK: - RequestProtocol
extension ThreadByIdRequest: RequestProtocol {
    
    var path: String {
        "/threads/\(threadId)"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}
