//
//  AttachmentsConversionService.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 08.03.2024.
//

import Foundation

protocol AttachmentsConversionServiceProtocol {
    func convertToFileContainers(attachments: [Attachment]) -> [FileContainer]
}

class AttachmentsConversionService: AttachmentsConversionServiceProtocol {
    
    func convertToFileContainers(attachments: [Attachment]) -> [FileContainer] {
        return attachments.compactMap {
            switch $0.type {
            case .photo(let format):
                let formatString = format.rawValue
                guard let mimeType = mimeTypes[formatString] else {
                    return nil
                }
                return FileContainer(fileName: "\(UUID()).\(format.rawValue)",
                                     data: $0.data,
                                     mimeType: mimeType)
            }
        }
    }
}
