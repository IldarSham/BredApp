//
//  Thread.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 17.02.2024.
//

import Foundation

struct Thread: Decodable {
    let threadId: Int
    let title: String
    let messages: [Message]
    let creator: User
}
