//
//  PhotoDTOTests.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import XCTest
@testable import Picture

final class PhotoDTOTests: XCTestCase {

    func test_givenPhotoDTO_whenTransformToEntity_ShouldReturn_CorrectMapping() {
        // GIVEN
        let dto = PhotoDTO(
            id: "id",
            description: "This is awesome",
            likes: 10,
            urls: .init(regular: URL(string: "https://google.com/1"), small: URL(string: "https://google.com/2")),
            user: .init(
                id: "id",
                username: "username",
                name: "name",
                profileImage: .init(
                    small: URL(string: "https://google.com/3"),
                    medium: URL(string: "https://google.com/4")
                )
            )
        )

        // WHEN
        let entity = dto.toEntity()

        // THEN
        XCTAssertEqual(dto.id, entity?.id)
        XCTAssertEqual(dto.description, entity?.description)
        XCTAssertEqual(dto.likes, entity?.likes)
        XCTAssertEqual(dto.urls?.small, entity?.image.small)
        XCTAssertEqual(dto.urls?.regular, entity?.image.medium)

        XCTAssertEqual(dto.user?.id, entity?.user.id)
        XCTAssertEqual(dto.user?.name, entity?.user.name)
        XCTAssertEqual(dto.user?.profileImage?.medium, entity?.user.profileImage.medium)
        XCTAssertEqual(dto.user?.profileImage?.small, entity?.user.profileImage.small)
    }
}
