//
//  TodayViewState.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

extension TodayViewModel {

    enum ViewState {
        case idle
        case loading(content: Loading)
        case loaded(content: Loaded)
        case selected(selectedPhoto: Photo)

        struct Loading: Equatable {
            let header: TodayCollectionViewHeaderModel
        }

        struct Loaded: Equatable {
            let cells: [TodayCollectionViewCellModel]
        }
    }

}
