//
//  GetUserPhotosListUseCase.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine

protocol GetUserPhotosListUseCaseProtocol {
    func execute(username: String) -> AnyPublisher<[Photo], any Error>
}

final class GetUserPhotosListUseCase {
    private let repository: any UsersRepositoryProtocol

    init(repository: some UsersRepositoryProtocol = UsersRepository()) {
        self.repository = repository
    }
}

// MARK: - GetUserPhotosListUseCaseProtocol

extension GetUserPhotosListUseCase: GetUserPhotosListUseCaseProtocol {
    func execute(username: String) -> AnyPublisher<[Photo], any Error> {
        return self.repository.getPhotos(username: username)
    }
}
