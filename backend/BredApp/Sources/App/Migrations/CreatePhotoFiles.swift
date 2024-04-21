//
//  CreatePhotoFiles.swift
//
//
//  Created by Ildar Shamsullin on 29.02.2024.
//
 
import Fluent

struct CreatePhotoFiles: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("photo-files")
            .field("id", .int, .identifier(auto: true))
            .field("path", .string, .required)
            .field("width", .int, .required)
            .field("height", .int, .required)
            .field("file_size", .int, .required)
            .field("message_id", .uuid, .required, .references("messages", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("photo-files").delete()
    }
}
