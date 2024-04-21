//
//  FileContainer.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 16.02.2024.
//

import Foundation

struct FileContainer {
    let fileName: String
    let data: Data
    let mimeType: String
    
    init(fileName: String, data: Data, mimeType: String) {
        self.fileName = fileName
        self.data = data
        self.mimeType = mimeType
    }
}
