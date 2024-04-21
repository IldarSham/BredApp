//
//  Data+appendString.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 16.02.2024.
//

import Foundation

extension Data {
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
