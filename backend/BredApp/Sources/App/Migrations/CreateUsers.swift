//
//  CreateUsers.swift
//
//
//  Created by Ildar Shamsullin on 14.01.2024.
//

import Fluent

struct CreateUsers: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .field("id", .int, .identifier(auto: true))
            .field("username", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .unique(on: "username")
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}
