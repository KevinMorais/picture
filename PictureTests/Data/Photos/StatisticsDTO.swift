//
//  StatisticsDTO.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import XCTest
@testable import Picture

final class StatisticsDTOTests: XCTestCase {

    func test_givenStatisticsoDTO_whenTransformToEntity_ShouldReturnCorrectMapping() {
        // GIVEN
        let dto = StatisticsDTO(
            id: "id",
            downloads: .init(total: 100),
            views: .init(total: 200),
            likes: .init(total: 2000)
        )

        // WHEN
        let entity = dto.toEntity()

        // THEN
        XCTAssertEqual(dto.id, entity?.id)
        XCTAssertEqual(dto.downloads?.total, entity?.totalDownload)
        XCTAssertEqual(dto.views.total, entity?.totalViews)
        XCTAssertEqual(dto.likes.total, entity?.totalLikes)
    }

}
