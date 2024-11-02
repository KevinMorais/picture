//
//  UserDTO.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

struct UserDTO: Decodable {
    let id: String?
    let username: String?
    let name: String?
    let profileImage: ProfileImageDTO?

    struct ProfileImageDTO: Decodable {
        let small: URL?
        let medium: URL?
    }
}

// MARK: - DTOToEntityProtocol

extension UserDTO: DTOToEntityProtocol {

    func toEntity() -> User? {
        guard let id = self.id,
              let username = self.username,
              let name = self.name,
              let profileImage = self.profileImage?.toEntity() else {
            assertionFailure("Missing mandatory properties")
            return nil
        }
        return .init(
            id: id,
            username: username,
            name: name,
            profileImage: profileImage
        )
    }
}

extension UserDTO.ProfileImageDTO: DTOToEntityProtocol {

    func toEntity() -> Image? {
        guard let small = self.small,
              let medium = self.medium else {
            assertionFailure("Missing mandatory properties")
            return nil
        }
        return .init(small: small, medium: medium)
    }
}
