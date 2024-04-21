//
//  MultipartEncoder.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 17.02.2024.
//

import Foundation

protocol MultipartEncodable {
    func encode(with data: MultipartDataProtocol) throws
}

class MultipartEncoder {
    var multipartData: MultipartData
    
    init(boundary: String) {
        self.multipartData = MultipartData(boundary: boundary)
    }
    
    func encode<T>(params: T) throws -> Data where T: MultipartEncodable {
        try params.encode(with: multipartData)
        multipartData.finalizeBody()
        return multipartData.body
    }
}
