//
//  TodayCollectionViewCellModel.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

struct TodayCollectionViewCellModel: Equatable {

    let imageURL: URL
    let title: String?
    let userInfo: UserInfo

    struct UserInfo: Equatable {
        let title: String
        let imageURL: URL
        let numberOfLikes: String
    }
}
