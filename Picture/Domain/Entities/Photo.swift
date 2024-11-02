//
//  Photo.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

struct Photo: Equatable {
    let id: String
    let description: String?
    let image: Image
    let likes: Int
    let user: User
}
