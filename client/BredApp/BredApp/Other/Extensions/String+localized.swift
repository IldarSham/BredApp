//
//  String+localized.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 22.12.2023.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
