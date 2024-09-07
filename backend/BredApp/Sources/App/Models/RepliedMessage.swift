//
//  RepliedMessage.swift
//
//
//  Created by Ildar Shamsullin on 06.09.2024.
//

import Vapor

struct RepliedMessage: Content {
    let messageId: Message.IDValue
    let from: User.Public
}

extension RepliedMessage {
    static func createFrom(message: Message) throws -> RepliedMessage {
        try RepliedMessage(messageId: message.requireID(), from: message.user.asPublic())
    }
}
