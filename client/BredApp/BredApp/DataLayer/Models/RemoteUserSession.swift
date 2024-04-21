//
//  RemoteUserSession.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.01.2024.
//

import Foundation

struct RemoteUserSession: Codable {
    let token: String
    let user: User
}
