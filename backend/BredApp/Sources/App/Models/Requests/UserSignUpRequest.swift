//
//  UserSignUpRequest.swift
//
//
//  Created by Ildar Shamsullin on 19.02.2024.
//

import Vapor

struct UserSignUpRequest: Content {
    let username: String
    let email: String
    let password: String
}
