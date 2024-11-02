//
//  SafeCollection.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
