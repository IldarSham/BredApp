//
//  CreateThreads.swift
//
//
//  Created by Ildar Shamsullin on 07.02.2024.
//

import Fluent

struct CreateThreads: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("threads")
            .field("id", .int, .identifier(auto: true))
            .field("preview_photo", .int, .references("photo-files", "id"))
            .field("title", .string, .required)
            .field("user_id", .int, .references("users", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("threads").delete()
    }
}
