//
//  CreateMessageRequest.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 08.03.2024.
//

import Foundation

struct CreateMessageRequest: MultipartEncodable {
    let threadId: Int
    let content: String
    let files: [FileContainer]?
    
    func encode(with data: MultipartDataProtocol) throws {
        data.append("threadId", threadId)
        data.append("content", content)
        files?.forEach { data.appendFile("files[]", $0) }
    }
}

// MARK: - RequestProtocol
extension CreateMessageRequest: RequestProtocol {
    
    var path: String {
        "/messages/create"
    }
    
    var httpMethod: HTTPMethod {
        .post
    }
}
