//
//  ThreadPreview.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.02.2024.
//

import Foundation

struct ThreadPreview: Decodable {
    let threadId: Int
    let previewPhoto: PhotoFile?
    let title: String
    let messagesCount: Int
    let filesCount: Int
    let content: String
}
