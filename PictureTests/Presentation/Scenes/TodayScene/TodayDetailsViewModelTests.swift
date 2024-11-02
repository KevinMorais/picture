//
//  TodayDetailsViewModelTests.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import XCTest
import Combine
@testable import Picture

final class TodayDetailsViewModelTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    func test_givenViewModel_WhenViewEventsReceived_ThenShouldUpdateState() {

        // GIVEN
        let selectedPhoto = Photo.mock(image: .mock(medium: URL(string: "https://photo.medium.com")!))

        let getUserPhotosListUseCaseMock = GetUserPhotosListUseCaseProtocolMock()
        getUserPhotosListUseCaseMock.executeResult = [selectedPhoto]

        let getPhotoStatisticsUseCaseMock = GetPhotoStatisticsUseCaseProtocolMock()
        getPhotoStatisticsUseCaseMock.executeResult = .init(id: "id", totalDownload: 1, totalViews: 2, totalLikes: 3)

        let viewModel = TodayDetailsViewModel(
            getUserPhotosListUseCase: getUserPhotosListUseCaseMock,
            getPhotoStatisticsUseCase: getPhotoStatisticsUseCaseMock,
            dataSource: .init(selectedPhoto: selectedPhoto)
        )
        let eventsExpectation = self.expectation(description: "Should collect states from events")

        var receivedOutputsStates: [TodayDetailsViewModel.ViewState] = []

        viewModel.viewState
            .collect()
            .sink { states in
                receivedOutputsStates = states
                eventsExpectation.fulfill()
            }
            .store(in: &self.subscriptions)

        // WHEN
        viewModel.event.send(.idle)
        viewModel.event.send(.viewDidLoad)
        viewModel.event.send(completion: .finished)

        // THEN
        wait(for: [eventsExpectation], timeout: 0.2)

        let loadingCells = Array(repeating: TodayDetailsPhotoCollectionViewCellModel(imageURL: nil), count: TodayDetailsViewModel.Constants.numberOfVisiblePhotos)

        let expectedOutput: [TodayDetailsViewModel.ViewState] = [
            .loading(content: .init(cells: loadingCells)),
            .loading(content: .init(cells: loadingCells)),
            .loadedPhotos(content: .init(cells: [.init(imageURL: URL(string: "https://photo.medium.com")!)])),
            .loadedStatistics(content: .init(
                header: .init(title: "Picture Statistics"),
                cells: [
                    .init(imageName: "numbers-of-views", text: "2 views"),
                    .init(imageName: "download", text: "1 downloads")
                ]
            ))
        ]
        XCTAssertEqual(receivedOutputsStates, expectedOutput)
        XCTAssertEqual(getUserPhotosListUseCaseMock.executeHasBeenCalledCount, 1)
        XCTAssertEqual(getPhotoStatisticsUseCaseMock.executeHasBeenCalledCount, 1)
    }
}

extension TodayDetailsViewModel.ViewState: Equatable {
    public static func == (lhs: Picture.TodayDetailsViewModel.ViewState, rhs: Picture.TodayDetailsViewModel.ViewState) -> Bool {
        switch (lhs, rhs) {
        case let (.loading(lhsContent), .loading(rhsContent)):
            return lhsContent == rhsContent
        case let (.loadedPhotos(lhsContent), .loadedPhotos(rhsContent)):
            return lhsContent == rhsContent
        case let(.loadedStatistics(lhsContent), .loadedStatistics(rhsContent)):
            return lhsContent == rhsContent
        default: return false
        }
    }
}
