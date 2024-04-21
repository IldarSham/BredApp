//
//  User.swift
//
//
//  Created by Ildar Shamsullin on 19.01.2024.
//

import Fluent
import Vapor

final class User: Model {
    static let schema = "users"
    
    struct Public: Content {
        let id: User.IDValue
        let username: String
    }
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    init() { }
    
    init(id: Int? = nil, username: String, email: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
    }
}

extension User {
    static func create(from signUpData: UserSignUpRequest) throws -> User {
        User(username: signUpData.username, email: signUpData.email, passwordHash: try Bcrypt.hash(signUpData.password))
    }
    
    func asPublic() throws -> Public {
        return try Public(id: self.requireID(),
                          username: self.username)
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$username
    static var passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
