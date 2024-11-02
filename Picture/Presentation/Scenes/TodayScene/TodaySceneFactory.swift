//
//  TodaySceneFactory.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

protocol TodaySceneFactoryProtocol {
    func createTodayViewController(coordinator: TodayCoordinatorDelegate) -> UIViewController
    func createTodayDetailsViewController(dataSource: TodayDetailsViewModelDataSource, coordinator: TodayCoordinatorDelegate) -> UIViewController
}

final class TodaySceneFactory: TodaySceneFactoryProtocol {

    func createTodayViewController(coordinator: TodayCoordinatorDelegate) -> UIViewController {
        let viewModel = TodayViewModel(getTodayPhotosListUseCase: GetTodayPhotosListUseCase())
        let viewController = TodayViewController(viewModel: viewModel, coordinator: coordinator)
        return viewController
    }

    func createTodayDetailsViewController(
        dataSource: TodayDetailsViewModelDataSource,
        coordinator: TodayCoordinatorDelegate
    ) -> UIViewController {
        let viewModel = TodayDetailsViewModel(
            getUserPhotosListUseCase: GetUserPhotosListUseCase(),
            getPhotoStatisticsUseCase: GetPhotoStatisticsUseCase(),
            dataSource: dataSource
        )
        let viewController = TodayDetailsViewController(viewModel: viewModel, coordinator: coordinator)
        return viewController
    }
}
