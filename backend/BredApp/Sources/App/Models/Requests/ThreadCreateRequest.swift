//
//  ThreadCreateRequest.swift
//
//
//  Created by Ildar Shamsullin on 19.02.2024.
//

import Vapor

struct ThreadCreateRequest: Content {
    let title: String
    let content: String
    let files: [File]
}
