//
//  DTO+Entity.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

protocol DTOToEntityProtocol {
    associatedtype Entity
    func toEntity() -> Entity?
}
