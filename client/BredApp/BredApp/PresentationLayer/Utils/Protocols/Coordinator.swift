//
//  Coordinator.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 25.01.2024.
//

import Foundation

protocol Coordinator: AnyObject {
    var router: Router { get }
    func start()
}
