//
//  GetTodayPhotosListUseCase.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine

protocol GetTodayPhotosListUseCaseProtocol {
    func execute() -> AnyPublisher<[Photo], any Error>
}

final class GetTodayPhotosListUseCase {

    private let repository: any PhotosRepositoryProtocol

    init(repository: some PhotosRepositoryProtocol = PhotosRepository()) {
        self.repository = repository
    }
}

// MARK: - GetTodayPhotosListProtocol

extension GetTodayPhotosListUseCase: GetTodayPhotosListUseCaseProtocol {
    func execute() -> AnyPublisher<[Photo], any Error> {
        return self.repository.get()
    }
}
