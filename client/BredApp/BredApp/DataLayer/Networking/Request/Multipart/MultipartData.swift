//
//  MultipartData.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 16.02.2024.
//

import Foundation

protocol MultipartDataProtocol {
    func append(_ key: String, _ value: Any)
    func appendFile(_ key: String, _ file: FileContainer)
}

class MultipartData: MultipartDataProtocol {
    
    var body = Data()
    var _boundary = ""
    private var boundaryPrefix = ""
    private var finishBoundary = ""
    private var boundary: String {
        set {
            _boundary = newValue
            boundaryPrefix = "--\(newValue)\r\n"
            finishBoundary = "--\(self.boundary)--"
        }
        get { return _boundary }
    }
    
    init(boundary: String) {
        self.boundary = boundary
    }
    
    func append(_ key: String, _ value: Any) {
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString("\(value)\r\n")
    }

    func appendFile(_ key: String, _ file: FileContainer) {
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(file.fileName)\"\r\n")
        body.appendString("Content-Type: \(file.mimeType)\r\n\r\n")
        body.append(file.data)
        body.appendString("\r\n")
    }
    
    func finalizeBody() {
        body.appendString(finishBoundary)
    }
}
