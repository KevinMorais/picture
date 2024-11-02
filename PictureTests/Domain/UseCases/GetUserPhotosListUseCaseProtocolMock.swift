//
//  GetUserPhotosListUseCaseProtocolMock.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import Combine
@testable import Picture

final class GetUserPhotosListUseCaseProtocolMock: GetUserPhotosListUseCaseProtocol {

    var executeHasBeenCalledCount: Int = 0
    var executeResult: [Photo] = []
    var receivedUsername: String?

    func execute(username: String) -> AnyPublisher<[Photo], any Error> {
        self.executeHasBeenCalledCount += 1
        self.receivedUsername = username
        return Just(executeResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

}
