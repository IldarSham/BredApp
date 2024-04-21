//
//  SignUpRequest.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 02.02.2024.
//

import Foundation

struct SignUpRequest: Encodable {
    let username: String
    let email: String
    let password: String
}

// MARK: - RequestProtocol
extension SignUpRequest: RequestProtocol {
    
    var path: String {
        "/users/signup"
    }
    
    var httpMethod: HTTPMethod {
        .post
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}
