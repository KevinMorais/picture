//
//  PhotoDTO.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: String?
    let description: String?
    let likes: Int?
    let urls: UrlsDTO?
    let user: UserDTO?

    struct UrlsDTO: Decodable {
        let regular: URL?
        let small: URL?
    }
}

// MARK: - DTOToEntityProtocol

extension PhotoDTO: DTOToEntityProtocol {

    func toEntity() -> Photo? {
        guard let id = self.id,
              let likes = self.likes,
              let smallImage = self.urls?.small,
              let mediumImage = self.urls?.regular,
              let user = self.user?.toEntity() else {
            assertionFailure("Missing mandatory properties")
            return nil
        }
        return .init(
            id: id,
            description: self.description,
            image: .init(small: smallImage, medium: mediumImage),
            likes: likes,
            user: user
        )
    }
}
