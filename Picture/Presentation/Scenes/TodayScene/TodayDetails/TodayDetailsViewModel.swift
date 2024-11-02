//
//  TodayDetailsViewModel.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine

protocol TodayDetailsViewModelInput {
    var event: CurrentValueSubject<TodayDetailsViewModel.ViewEvent, Never> { get }
}

protocol TodayDetailsViewModelOutput {
    var viewState: AnyPublisher<TodayDetailsViewModel.ViewState, Never> { get }
}

typealias TodayDetailsViewModelProtocol = TodayDetailsViewModelInput & TodayDetailsViewModelOutput

struct TodayDetailsViewModelDataSource {
    let selectedPhoto: Photo
}

final class TodayDetailsViewModel: TodayDetailsViewModelProtocol {

    enum Constants {
        static let numberOfVisiblePhotos: Int = 4
    }

    // MARK: - Input
    var event: CurrentValueSubject<ViewEvent, Never> = .init(.idle)

    // MARK: - Output
    lazy var viewState: AnyPublisher<ViewState, Never> = {
        self.transform(event: self.event.eraseToAnyPublisher())
    }()

    private let getUserPhotosListUseCase: any GetUserPhotosListUseCaseProtocol
    private let getPhotoStatisticsUseCase: any GetPhotoStatisticsUseCaseProtocol
    private let dataSource: TodayDetailsViewModelDataSource

    private var subscriptions = Set<AnyCancellable>()

    init(
        getUserPhotosListUseCase: any GetUserPhotosListUseCaseProtocol,
        getPhotoStatisticsUseCase: any GetPhotoStatisticsUseCaseProtocol,
        dataSource: TodayDetailsViewModelDataSource
    ) {
        self.getUserPhotosListUseCase = getUserPhotosListUseCase
        self.getPhotoStatisticsUseCase = getPhotoStatisticsUseCase
        self.dataSource = dataSource
    }

    private func transform(event: AnyPublisher<ViewEvent, Never>) -> AnyPublisher<ViewState, Never> {
        let idleEvent = self.idleEvent(event: event)
        let viewDidLoadEvent = self.viewDidLoadEvent(event: event)
        return Publishers
            .Merge(idleEvent, viewDidLoadEvent)
            .eraseToAnyPublisher()
    }

    private func idleEvent(event: AnyPublisher<ViewEvent, Never>) -> AnyPublisher<ViewState, Never> {
        return event.filter { $0 == .idle }
            .map { _ in ViewState.loading(content: self.buildEmptyPhotoCell()) }
            .eraseToAnyPublisher()
    }

    private func viewDidLoadEvent(event: AnyPublisher<ViewEvent, Never>) -> AnyPublisher<ViewState, Never> {

        let receivedPhotoList = self.didReceivedPhotoList(event: event)
        let receivedStatistics = self.didReceivedStatistics(event: event)

        return Publishers
            .Merge(receivedPhotoList, receivedStatistics)
            .eraseToAnyPublisher()
    }

    private func didReceivedPhotoList(event: AnyPublisher<ViewEvent, Never>) -> AnyPublisher<ViewState, Never> {
        return event
            .filter { $0 == .viewDidLoad }
            .setFailureType(to: Error.self)
            .flatMap { _ in
                return self.getUserPhotosListUseCase.execute(username: self.dataSource.selectedPhoto.user.username)
            }
            .replaceError(with: [])
            .map { ViewState.loadedPhotos(content: self.buildLoadedPhotos(photos: $0)) }
            .share()
            .eraseToAnyPublisher()
    }

    private func didReceivedStatistics(event: AnyPublisher<ViewEvent, Never>) -> AnyPublisher<ViewState, Never> {
        return event
            .filter { $0 == .viewDidLoad }
            .setFailureType(to: Error.self)
            .flatMap { _ in
                return self.getPhotoStatisticsUseCase.execute(photoId: self.dataSource.selectedPhoto.id)
            }
            .catch { _ in Empty<Statistics, Never>(completeImmediately: false) }
            .map { ViewState.loadedStatistics(content: self.buildLoadedStatistics(statistics: $0)) }
            .eraseToAnyPublisher()
    }
}

// MARK: - Builders

private extension TodayDetailsViewModel {

    private func insertSelectedPhoto(photos: [Photo]) -> [Photo] {
        var mutablePhotos = photos
        if let selectedPhotoIndex = mutablePhotos.firstIndex(where: { $0.id == self.dataSource.selectedPhoto.id }) {
            mutablePhotos.remove(at: selectedPhotoIndex)
        }
        mutablePhotos.insert(self.dataSource.selectedPhoto, at: 0)
        return mutablePhotos
    }

    private func buildLoadedPhotos(photos: [Photo]) -> ViewState.PhotoContent {
        let updatedPhotos = self.insertSelectedPhoto(photos: photos)
        return .init(
            cells: updatedPhotos.prefix(Constants.numberOfVisiblePhotos).map {
                return .init(imageURL: $0.image.medium)
            }
        )
    }

    private func buildEmptyPhotoCell() -> ViewState.PhotoContent {
        let emptyCellModel = TodayDetailsPhotoCollectionViewCellModel(imageURL: nil)
        return .init(
            cells: Array(repeating: emptyCellModel, count: Constants.numberOfVisiblePhotos)
        )
    }

    private func buildLoadedStatistics(statistics: Statistics) -> ViewState.StatisticsContent {
        return .init(
            header: .init(title: "Picture Statistics"),
            cells: [
                .init(imageName: "numbers-of-views", text: "\(statistics.totalViews) views"),
                .init(imageName: "download", text: "\(statistics.totalDownload) downloads")
            ]
        )
    }
}
