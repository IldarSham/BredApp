//
//  RepliedMessage.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 06.09.2024.
//

import Foundation

struct RepliedMessage: Decodable {
    let messageId: Int
    let from: User
}
