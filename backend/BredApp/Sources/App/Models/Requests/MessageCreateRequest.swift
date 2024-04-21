//
//  MessageCreateRequest.swift
//
//
//  Created by Ildar Shamsullin on 20.02.2024.
//

import Vapor

struct MessageCreateRequest: Content {
    let threadId: Int
    let content: String
    let files: [File]?
}
