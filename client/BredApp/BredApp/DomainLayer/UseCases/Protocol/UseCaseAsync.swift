//
//  UseCaseAsync.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 03.02.2024.
//

import Foundation

protocol UseCaseAsync<T> {
    associatedtype T
    func start() async throws -> T
}
