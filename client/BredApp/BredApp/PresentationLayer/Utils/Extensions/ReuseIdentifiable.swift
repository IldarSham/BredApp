//
//  ReuseIdentifiable.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 06.02.2024.
//

import UIKit

protocol ReuseIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UICollectionViewCell: ReuseIdentifiable {}
extension UITableViewCell: ReuseIdentifiable {}
