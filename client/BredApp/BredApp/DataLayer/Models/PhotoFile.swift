//
//  PhotoFile.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 17.02.2024.
//

import Foundation

struct PhotoFile: Decodable {
    let url: URL
    let width: Int
    let height: Int
    let fileSize: Int
}
