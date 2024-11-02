//
//  TodayViewModel.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine

protocol TodayViewModelInput {
    var event: CurrentValueSubject<TodayViewModel.ViewEvent, Never> { get }
}

protocol TodayViewModelOutput {
    var viewState: AnyPublisher<TodayViewModel.ViewState, Never> { get }
}

typealias TodayViewModelProtocol = TodayViewModelInput & TodayViewModelOutput

final class TodayViewModel: TodayViewModelProtocol {

    // MARK: - Input
    var event: CurrentValueSubject<ViewEvent, Never> = .init(.idle)

    // MARK: - Output
    lazy var viewState: AnyPublisher<ViewState, Never> = {
        self.transform(event: self.event.eraseToAnyPublisher())
    }()

    private let getTodayPhotosListUseCase: any GetTodayPhotosListUseCaseProtocol

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d yy"
        return formatter
    }()

    init(
        getTodayPhotosListUseCase: any GetTodayPhotosListUseCaseProtocol
    ) {
        self.getTodayPhotosListUseCase = getTodayPhotosListUseCase
    }

    private func transform(event: AnyPublisher<ViewEvent, Never>) -> AnyPublisher<ViewState, Never> {
        let receivedPhotosPublisher = self.didReceivedPhotosPublisher(event: event)
        let selectedItemPublisher = self.selectedItemEvent(event: event, receivedPhotosPublisher: receivedPhotosPublisher)
        let viewDidLoadPublisher = self.viewDidLoadEvent(event: event, receivedPhotosPublisher: receivedPhotosPublisher)
        return Publishers.Merge(viewDidLoadPublisher, selectedItemPublisher)
            .eraseToAnyPublisher()
    }

    private func viewDidLoadEvent(event: AnyPublisher<ViewEvent, Never>, receivedPhotosPublisher: AnyPublisher<[Photo], Never>) -> AnyPublisher<ViewState, Never> {
        let loadingEventPublisher = event
            .filter { $0 == .viewDidLoad }
            .map { _ in ViewState.loading(content: self.buildLoadingContent()) }
            .eraseToAnyPublisher()

        return Publishers
            .Merge(
                loadingEventPublisher,
                receivedPhotosPublisher
                    .map { ViewState.loaded(content: self.buildLoadedContent(photos: $0)) }
            )
            .eraseToAnyPublisher()
    }

    private func selectedItemEvent(event: AnyPublisher<ViewEvent, Never>, receivedPhotosPublisher: AnyPublisher<[Photo], Never>) -> AnyPublisher<ViewState, Never> {
        let selectedIndexPublisher = event
            .compactMap { event -> Int? in
                guard case let .selectItem(index) = event else {
                    return nil
                }
                return index
            }
            .eraseToAnyPublisher()

        return Publishers
            .CombineLatest(selectedIndexPublisher, receivedPhotosPublisher)
            .compactMap { (index, photos) in
                guard let selectedPhoto = photos[safe: index] else {
                    return nil
                }
                return ViewState.selected(selectedPhoto: selectedPhoto)
            }
            .eraseToAnyPublisher()
    }

    private func didReceivedPhotosPublisher(event: AnyPublisher<ViewEvent, Never>) -> AnyPublisher<[Photo], Never> {
        return event
            .filter { $0 == .viewDidLoad }
            .setFailureType(to: Error.self)
            .flatMap { _ in
                return self.getTodayPhotosListUseCase.execute()
            }
            .replaceError(with: [])
            .share()
            .eraseToAnyPublisher()
    }
}

// MARK: - Builders

private extension TodayViewModel {

    private func buildLoadingContent() -> ViewState.Loading {
        return .init(
            header: .init(dateText: self.dateFormatter.string(from: Date()), todayText: "Today")
        )
    }

    private func buildLoadedContent(photos: [Photo]) -> ViewState.Loaded {
        return  .init(
            cells: self.buildCells(photos: photos)
        )
    }

    private func buildCells(photos: [Photo]) -> [TodayCollectionViewCellModel] {
        return photos.map {
            return .init(
                imageURL: $0.image.medium,
                title: $0.description,
                userInfo: .init(
                    title: $0.user.name,
                    imageURL: $0.user.profileImage.medium,
                    numberOfLikes: "\($0.likes) likes"
                )
            )
        }
    }
}
