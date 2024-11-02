//
//  Mocks.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
@testable import Picture

extension Photo {

    static func mock(
        id: String = "id",
        description: String = "description",
        image: Image = .mock(),
        likes: Int = 200,
        user: User = .mock()
    ) -> Photo {
        return .init(id: id, description: description, image: image, likes: likes, user: user)
    }
}

extension Image {

    static func mock(
        small: URL = URL(string: "https://google.com/1")!,
        medium: URL = URL(string: "https://google.com/2")!
    ) -> Image {
        return .init(small: small, medium: medium)
    }
}

extension User {

    static func mock(
        id: String = "id",
        username: String = "username",
        name: String = "name",
        image: Image = .mock()
    ) -> User {
        return .init(
            id: id,
            username: username,
            name: name,
            profileImage: image
        )
    }
}
