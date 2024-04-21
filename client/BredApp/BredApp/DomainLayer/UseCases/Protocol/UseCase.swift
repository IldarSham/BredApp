//
//  UseCase.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 26.01.2024.
//

import Foundation

protocol UseCase<T> {
    associatedtype T
    func start() throws -> T
}
