//
//  TodayViewEvent.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

extension TodayViewModel {

    enum ViewEvent: Equatable {
        case idle
        case viewDidLoad
        case selectItem(index: Int)
    }

}
