//
//  UICollectionView+Reusable.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

public protocol Reusable {
    static var ReuseIdentifier: String { get }
}

public extension Reusable {
    static var ReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {}
