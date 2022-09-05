//
//  ReusableCell.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

/// A protocol that generates reuse identifier from class name.
public protocol ReusableCell {
    /// You can use this property as unique reuse identifier for specified UICollectionViewCell or UITableViewCell subclass.
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
