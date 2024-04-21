//
//  NewMessage.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 08.03.2024.
//

import Foundation

struct NewMessage {
    let threadId: Int
    let content: String
    let attachments: [Attachment]
}
