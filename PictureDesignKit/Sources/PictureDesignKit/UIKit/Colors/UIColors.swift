//
//  UIColors.swift
//
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

extension UIColor {

    private static func color(named: String) -> UIColor {
        return .init(named: named, in: .module, compatibleWith: .current)!
    }

    public static let background: UIColor? = {
        return color(named: "backgroundColor")
    }()

    public static let onBackground: UIColor? = {
        return color(named: "onBackgroundColor")
    }()

    public static let tertiary: UIColor? = {
        return color(named: "tertiaryColor")
    }()

    public static let fixedWhite: UIColor? = {
        return .white
    }()
}
