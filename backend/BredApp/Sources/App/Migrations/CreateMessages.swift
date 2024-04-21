//
//  CreateMessages.swift
//
//
//  Created by Ildar Shamsullin on 09.02.2024.
//

import Fluent

struct CreateMessages: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("messages")
            .field("id", .int, .identifier(auto: true))
            .field("created_at", .datetime)
            .field("content", .string, .required)
            .field("thread_id", .int, .required, .references("threads", "id", onDelete: .cascade))
            .field("user_id", .int, .references("users", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("messages").delete()
    }
}
