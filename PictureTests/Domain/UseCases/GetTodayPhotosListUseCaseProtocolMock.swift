//
//  GetTodayPhotosListUseCaseProtocolMock.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import Combine
@testable import Picture

final class GetTodayPhotosListUseCaseProtocolMock: GetTodayPhotosListUseCaseProtocol {

    var executeHasBeenCalledCount: Int = 0
    var executeResult: [Photo] = []

    func execute() -> AnyPublisher<[Photo], any Error> {
        self.executeHasBeenCalledCount += 1
        return Just(executeResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
