//
//  RemoteAPIManagerProtocol.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.02.2024.
//

import Foundation

protocol RemoteAPIManagerProtocol {
    func callAPI<T: Decodable>(with data: RequestProtocol, authToken: String?) async throws -> T
}

extension RemoteAPIManagerProtocol {
    func callAPI<T: Decodable>(with data: RequestProtocol, authToken: String? = nil) async throws -> T {
        return try await callAPI(with: data, authToken: authToken)
    }
}
