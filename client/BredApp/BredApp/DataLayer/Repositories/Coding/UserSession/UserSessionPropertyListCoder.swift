//
//  UserSessionPropertyListCoder.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 26.01.2024.
//

import Foundation

class UserSessionPropertyListCoder: UserSessionCoding {
    
    // MARK: - Methods
    func encode(userSession: RemoteUserSession) -> Data {
        return try! PropertyListEncoder().encode(userSession)
    }
    
    func decode(data: Data) -> RemoteUserSession {
        return try! PropertyListDecoder().decode(RemoteUserSession.self, from: data)
    }
}
