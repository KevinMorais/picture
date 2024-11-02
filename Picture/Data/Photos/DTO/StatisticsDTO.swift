//
//  StatisticsDTO.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

struct StatisticsDTO: Decodable {
    let id: String?
    let downloads: Downloads?
    let views: Views
    let likes: Likes

    struct Downloads: Decodable {
        let total: Int?
    }

    struct Views: Decodable {
        let total: Int?
    }

    struct Likes: Decodable {
        let total: Int?
    }
}

// MARK: - DTOToEntityProtocol

extension StatisticsDTO: DTOToEntityProtocol {
    func toEntity() -> Statistics? {
        guard let id,
              let totalDownloads = self.downloads?.total,
              let totalViews = self.views.total,
              let totalLikes = self.likes.total else {
            assertionFailure("Missing mandatory properties")
            return nil
        }
        return .init(
            id: id,
            totalDownload: totalDownloads,
            totalViews: totalViews,
            totalLikes: totalLikes
        )
    }
}
