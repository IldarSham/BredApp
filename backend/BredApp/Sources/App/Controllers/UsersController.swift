//
//  UsersController.swift
//  
//
//  Created by Ildar Shamsullin on 18.01.2024.
//

import Vapor

struct UserSession: Content {
    let token: String
    let user: User.Public
}

struct UsersController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.post("signup", use: signUpHandler)
        
        let basicAuthGroup = usersRoutes.grouped(User.authenticator())
        basicAuthGroup.post("login", use: loginHandler)
    }
    
    func signUpHandler(req: Request) async throws -> UserSession {
        let signUpData = try req.content.decode(UserSignUpRequest.self)
        
        let user = try User.create(from: signUpData)
        try await user.save(on: req.db)
        
        let token = try Token.generate(for: user)
        try await token.save(on: req.db)
        
        return UserSession(token: token.value,
                           user: try user.asPublic())
    }
    
    func loginHandler(req: Request) async throws -> UserSession {
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        
        try await token.save(on: req.db)
        
        return UserSession(token: token.value,
                           user: try user.asPublic())
    }
}
