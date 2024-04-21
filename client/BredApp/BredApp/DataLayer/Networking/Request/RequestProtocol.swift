//
//  RequestProtocol.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 02.02.2024.
//

import Foundation

protocol RequestProtocol {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var contentType: ContentType { get }
    var queryItems: [String: String] { get }
    var headers: [String: String] { get }
    var addAuthorizationToken: Bool { get }
}

extension RequestProtocol {
    
    var contentType: ContentType {
        .urlencoded
    }
    
    var queryItems: [String: String] {
        [:]
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var addAuthorizationToken: Bool {
        true
    }
}

extension RequestProtocol where Self: Encodable {
    
    var contentType: ContentType {
        .json
    }
}

extension RequestProtocol where Self: MultipartEncodable {
    
    var contentType: ContentType {
        .multipart
    }
}
