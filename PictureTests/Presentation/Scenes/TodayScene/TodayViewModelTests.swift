//
//  TodayViewModelTests.swift
//  PictureTests
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation
import XCTest
import Combine
@testable import Picture

final class TodayViewModelTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d yy"
        return formatter
    }()

    func test_givenViewModel_WhenViewEventsReceived_ThenShouldUpdateState() {

        // GIVEN
        let getTodayPhotoListUseCaseMock = GetTodayPhotosListUseCaseProtocolMock()
        let photo = Photo.mock(
            description: "description",
            image: .mock(medium: URL(string: "https://photo.medium.image.com")!),
            likes: 100,
            user: .mock(name: "name", image: .mock(medium: URL(string: "https://user.medium.image.com")!))
        )
        getTodayPhotoListUseCaseMock.executeResult = [photo]
        let viewModel = TodayViewModel(getTodayPhotosListUseCase: getTodayPhotoListUseCaseMock)

        let eventsExpectation = self.expectation(description: "Should collect states from events")

        var receivedOutputsStates: [TodayViewModel.ViewState] = []

        viewModel.viewState
            .collect()
            .sink { states in
                receivedOutputsStates = states
                eventsExpectation.fulfill()
            }
            .store(in: &self.subscriptions)

        // WHEN
        viewModel.event.send(.viewDidLoad)
        viewModel.event.send(.selectItem(index: 0))
        viewModel.event.send(completion: .finished)

        // THEN
        wait(for: [eventsExpectation], timeout: 0.2)

        let expectedOutput: [TodayViewModel.ViewState] = [
            .loading(content: .init(header: .init(dateText: dateFormatter.string(from: Date()), todayText: "Today"))),
            .loaded(content: .init(cells: [
                .init(
                    imageURL: URL(string: "https://photo.medium.image.com")!,
                    title: "description",
                    userInfo: .init(title: "name", imageURL: URL(string: "https://user.medium.image.com")!, numberOfLikes: "100 likes")
                )
            ])),
            .selected(selectedPhoto: photo)
        ]
        XCTAssertEqual(receivedOutputsStates, expectedOutput)
        XCTAssertEqual(getTodayPhotoListUseCaseMock.executeHasBeenCalledCount, 1)
    }

}

extension TodayViewModel.ViewState: Equatable {
    public static func == (lhs: Picture.TodayViewModel.ViewState, rhs: Picture.TodayViewModel.ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case let (.loading(lhsContent), .loading(rhsContent)):
            return lhsContent == rhsContent
        case let (.loaded(lhsContent), .loaded(rhsContent)):
            return lhsContent == rhsContent
        case let (.selected(lhsPhoto), .selected(rhsPhoto)):
            return lhsPhoto == rhsPhoto
        default: return false
        }
    }
}
