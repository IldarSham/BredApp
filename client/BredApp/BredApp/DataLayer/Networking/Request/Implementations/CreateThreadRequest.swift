//
//  CreateThreadRequest.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 12.02.2024.
//

import Foundation

struct CreateThreadRequest: MultipartEncodable {
    let title: String
    let content: String
    let files: [FileContainer]
    
    func encode(with data: MultipartDataProtocol) throws {
        data.append("title", title)
        data.append("content", content)
        files.forEach { data.appendFile("files[]", $0) }
    }
}

// MARK: - RequestProtocol
extension CreateThreadRequest: RequestProtocol {
    
    var path: String {
        "/threads/create"
    }
    
    var httpMethod: HTTPMethod {
        .post
    }
}
