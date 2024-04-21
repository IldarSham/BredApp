//
//  Message.swift
//
//
//  Created by Ildar Shamsullin on 08.02.2024.
//

import Fluent
import Vapor

final class Message: Model {
    static var schema = "messages"
    
    struct Public: Content {
        let messageId: Message.IDValue
        let createdAt: Int?
        let content: String
        let repliesToIds: [Message.IDValue]?
        let repliesByIds: [Message.IDValue]?
        let photo: [PhotoFile.Public]?
        let from: User.Public
    }
    
    @ID(custom: "id")
    var id: Int?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Field(key: "content")
    var content: String
    
    @Siblings(through: MessageReplyPivot.self, from: \.$repliedMessage, to: \.$message)
    var repliesTo: [Message]
    
    @Siblings(through: MessageReplyPivot.self, from: \.$message, to: \.$repliedMessage)
    var repliesBy: [Message]
    
    @Children(for: \.$message)
    var photo: [PhotoFile]
    
    @Parent(key: "thread_id")
    var thread: Thread
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: Int? = nil, content: String, thread: Thread, user: User) throws {
        self.id = id
        self.content = content
        self.$thread.id = try thread.requireID()
        self.$user.id = try user.requireID()
    }
}

extension Message {
    
    func asPublic() throws -> Message.Public {
        try Message.Public(messageId: self.requireID(),
                           createdAt: self.createdAt != nil ? Int(self.createdAt!.timeIntervalSince1970) : nil,
                           content: self.content,
                           repliesToIds: self.repliesTo.isEmpty ? nil : self.repliesTo.map { try $0.requireID() }, 
                           repliesByIds: self.repliesBy.isEmpty ? nil : self.repliesBy.map { try $0.requireID() },
                           photo: self.photo.isEmpty ? nil : self.photo.map { $0.asPublic() },
                           from: self.user.asPublic())
    }
}
