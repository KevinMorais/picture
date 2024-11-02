//
//  Fonts.swift
//
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

extension UIFont {

    public static var largeTitle: UIFont {
        return .systemFont(ofSize: 32, weight: .bold)
    }

    public static var mediumTitle: UIFont {
        return .systemFont(ofSize: 16, weight: .semibold)
    }

    public static var smallTitle: UIFont {
        return .systemFont(ofSize: 12, weight: .semibold)
    }

    public static var body: UIFont {
        return .systemFont(ofSize: 12, weight: .regular)
    }
}
