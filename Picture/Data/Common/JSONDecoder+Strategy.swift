//
//  JSONDecoder+Strategy.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

extension JSONDecoder {
    public static let defaultStrategy: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
