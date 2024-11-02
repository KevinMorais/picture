//
//  GetPhotoStatisticsUseCase.swift
//  Picture
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import Combine

protocol GetPhotoStatisticsUseCaseProtocol {
    func execute(photoId: String) -> AnyPublisher<Statistics, any Error>
}

final class GetPhotoStatisticsUseCase {
    private let repository: any PhotosRepositoryProtocol

    init(repository: some PhotosRepositoryProtocol = PhotosRepository()) {
        self.repository = repository
    }
}

// MARK: - GetPhotoStatisticsUseCaseProtocol

extension GetPhotoStatisticsUseCase: GetPhotoStatisticsUseCaseProtocol {
    func execute(photoId: String) -> AnyPublisher<Statistics, any Error> {
        return self.repository.getStatistics(photoId: photoId)
    }
}
