//
//  ThreadListRequest.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.02.2024.
//

import Foundation

struct ThreadListRequest {
    let page: Int
    let per: Int
}

// MARK: - RequestProtocol
extension ThreadListRequest: RequestProtocol {
    
    var path: String {
        "/threads"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var queryItems: [String: String] {
        [
            "page": "\(page)",
            "per": "\(per)",
        ]
    }
}
