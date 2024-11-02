//
//  TodayDetailsState.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

extension TodayDetailsViewModel {

    enum ViewState {
        case idle
        case loading(content: PhotoContent)
        case loadedPhotos(content: PhotoContent)
        case loadedStatistics(content: StatisticsContent)

        struct PhotoContent: Equatable {
            let cells: [TodayDetailsPhotoCollectionViewCellModel]
        }

        struct StatisticsContent: Equatable {
            let header: TodayDetailsStatisticsHeaderModel
            let cells: [TodayDetailsStatisticsCollectionViewCellModel]
        }
    }
}
