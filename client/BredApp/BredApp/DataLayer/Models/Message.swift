//
//  Message.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 17.02.2024.
//

import Foundation

struct Message: Decodable {
    let messageId: Int
    let createdAt: Int?
    let content: String
    let repliesToIds: [Int]?
    let repliesByIds: [Int]?
    let photo: [PhotoFile]?
    let from: User
}
