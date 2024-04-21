//
//  Token.swift
//
//
//  Created by Ildar Shamsullin on 20.01.2024.
//

import Fluent

final class Token: Model {
    static var schema = "tokens"
    
    @ID
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, value: String, userId: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userId
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = [UInt8].random(count: 16).base64
        return Token(value: random, userId: try user.requireID())
    }
}

extension Token: ModelTokenAuthenticatable {
    typealias User = App.User
    
    static var valueKey = \Token.$value
    static var userKey = \Token.$user
    
    var isValid: Bool {
        true
    }
}
