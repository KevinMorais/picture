//
//  PhotosRepository.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine
import PictureNetwork

protocol PhotosRepositoryProtocol {
    func get() -> AnyPublisher<[Photo], Error>
    func getStatistics(photoId: String) -> AnyPublisher<Statistics, Error>
}

final class PhotosRepository {

    enum Endpoint: String {
        case get = "/photos"
        case getStatistics = "/photos/%@/statistics"
    }

    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
}

// MARK: - PhotosRepositoryProtocol

extension PhotosRepository: PhotosRepositoryProtocol {

    func get() -> AnyPublisher<[Photo], Error> {
        return self.apiClient
            .get(path: Endpoint.get.rawValue)
            .tryMap { try JSONDecoder.defaultStrategy.decode([PhotoDTO].self, from: $0) }
            .map { $0.compactMap { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    func getStatistics(photoId: String) -> AnyPublisher<Statistics, any Error> {
        let endpoint = String(format: Endpoint.getStatistics.rawValue, photoId)
        return self.apiClient
            .get(path: endpoint)
            .tryMap { try JSONDecoder.defaultStrategy.decode(StatisticsDTO.self, from: $0) }
            .compactMap { $0.toEntity() }
            .eraseToAnyPublisher()
    }
}
