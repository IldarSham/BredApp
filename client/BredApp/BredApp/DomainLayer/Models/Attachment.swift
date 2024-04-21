//
//  Attachment.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 16.02.2024.
//

import Foundation

enum AttachmentType {
    case photo(format: ImageFormat)
}

struct Attachment {
    let type: AttachmentType
    let data: Data
}
