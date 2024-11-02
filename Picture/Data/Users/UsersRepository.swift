//
//  UsersRepository.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine
import PictureNetwork

protocol UsersRepositoryProtocol {
    func getPhotos(username: String) -> AnyPublisher<[Photo], Error>
}

final class UsersRepository {

    enum Endpoint: String {
        case getPhotos = "/users/%@/photos"
    }

    private let apiClient: any APIClientProtocol

    init(apiClient: some APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
}

// MARK: - UsersRepositoryProtocol

extension UsersRepository: UsersRepositoryProtocol {
    func getPhotos(username: String) -> AnyPublisher<[Photo], Error> {
        let endpoint = String(format: Endpoint.getPhotos.rawValue, username)
        return self.apiClient
            .get(path: endpoint)
            .tryMap { try JSONDecoder.defaultStrategy.decode([PhotoDTO].self, from: $0) }
            .map { $0.compactMap { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
}
