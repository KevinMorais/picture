//
//  GetPhotoStatisticsUseCaseProtocolMock.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import Combine
@testable import Picture

final class GetPhotoStatisticsUseCaseProtocolMock: GetPhotoStatisticsUseCaseProtocol {

    private enum DummyError: Error {
        case dummy
    }

    var executeHasBeenCalledCount: Int = 0
    var executeResult: Statistics?

    func execute(photoId: String) -> AnyPublisher<Statistics, any Error> {
        self.executeHasBeenCalledCount += 1
        guard let executeResult else {
            return Fail(error: DummyError.dummy).eraseToAnyPublisher()
        }
        return Just(executeResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
