//
//  SignInRequest.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 02.02.2024.
//

import Foundation

struct SignInRequest {
    let username: String
    let password: String
}

// MARK: - RequestProtocol
extension SignInRequest: RequestProtocol {
    
    var path: String {
        "/users/login"
    }
    
    var httpMethod: HTTPMethod {
        .post
    }
    
    var headers: [String: String] {
        [
            "Authorization": generateAuthString()
        ]
    }
    
    var addAuthorizationToken: Bool {
        false
    }
}

extension SignInRequest {
    
    private func generateAuthString() -> String {
        let userPasswordData = "\(username):\(password)".data(using: .utf8)!
        let base64EncodedCredential = userPasswordData.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        return authString
    }
}
