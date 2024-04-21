//
//  MessageReplyPivot.swift
//
//
//  Created by Ildar Shamsullin on 09.02.2024.
//

import Fluent

final class MessageReplyPivot: Model {
    static var schema = "messages-replies-pivot"
    
    @ID
    var id: UUID?
    
    @Parent(key: "message_id")
    var message: Message
    
    @Parent(key: "replied_message_id")
    var repliedMessage: Message
    
    init() {}
    
    init(id: UUID? = nil, message: Message, repliedMessage: Message) throws {
        self.id = id
        self.$message.id = try message.requireID()
        self.$repliedMessage.id = try repliedMessage.requireID()
    }
}
