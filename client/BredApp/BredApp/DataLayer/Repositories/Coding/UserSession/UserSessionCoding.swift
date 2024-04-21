//
//  UserSessionCoding.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 26.01.2024.
//

import Foundation

protocol UserSessionCoding {
    func encode(userSession: RemoteUserSession) -> Data
    func decode(data: Data) -> RemoteUserSession
}
