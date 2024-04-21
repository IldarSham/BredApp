//
//  CreateTokens.swift
//  
//
//  Created by Ildar Shamsullin on 20.01.2024.
//

import Fluent

struct CreateTokens: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field("user_id", .int, .references("users", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("tokens").delete()
    }
}
