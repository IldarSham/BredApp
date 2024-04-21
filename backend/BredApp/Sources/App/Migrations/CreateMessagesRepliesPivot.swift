//
//  CreateMessagesRepliesPivot.swift
//
//
//  Created by Ildar Shamsullin on 09.02.2024.
//

import Fluent

struct CreateMessagesRepliesPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("messages-replies-pivot")
            .id()
            .field("message_id", .int, .required, .references("messages", "id", onDelete: .cascade))
            .field("replied_message_id", .int, .required, .references("messages", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("messages-replies-pivot").delete()
    }
}
