//
//  Thread.swift
//
//
//  Created by Ildar Shamsullin on 07.02.2024.
//

import Fluent
import Vapor

final class Thread: Model {
    static var schema = "threads"
    
    struct Public: Content {
        let threadId: Thread.IDValue
        let title: String
        let messages: [Message.Public]
        let creator: User.Public
    }
    
    @ID(custom: "id")
    var id: Int?
    
    @OptionalParent(key: "preview_photo")
    var previewPhoto: PhotoFile?
        
    @Field(key: "title")
    var title: String
    
    @Children(for: \.$thread)
    var messages: [Message]
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: Int? = nil, previewPhoto: PhotoFile? = nil, title: String, user: User) throws {
        self.id = id
        self.$previewPhoto.id = try previewPhoto?.requireID()
        self.title = title
        self.$user.id = try user.requireID()
    }
}

extension Thread {
    
    static func setPreviewPhoto(
        _ photo: PhotoFile,
        thread: Thread,
        on req: Request
    ) async throws {
        if let thread = try await Thread.find(
            try thread.requireID(),
            on: req.db
        ) {
            thread.$previewPhoto.id = try photo.requireID()
            try await thread.update(on: req.db)
        }
    }
}

extension Thread {
    
    func asPublic() throws -> Thread.Public {
        try Thread.Public(threadId: self.requireID(),
                          title: self.title,
                          messages: self.messages.map { try $0.asPublic() }.sorted { $0.messageId < $1.messageId },
                          creator: self.user.asPublic())
    }
}

