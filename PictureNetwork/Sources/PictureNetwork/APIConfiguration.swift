//
//  APIConfiguration.swift
//
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation

public struct APIConfiguration {

    // swiftlint:disable all force_unwrapping
    private enum Constants {
        static let domain: URL = .init(string: "https://api.unsplash.com")!
        static let rangeSuccessCode: ClosedRange<Int> = (200...299)
        static let responseQueue: DispatchQueue = .main
        static let authorization: String = "Client-ID oXvBZWorfYtiYQvqI30VSM9Ng0cM0dWaGWDwpGynUR4"
    }

    let baseURL: URL = Constants.domain
    let rangeSuccessCode: ClosedRange<Int> = Constants.rangeSuccessCode
    let responseQueue: DispatchQueue = Constants.responseQueue

    let authorizationKey: String = "Authorization"
    let authorizationValue: String = Constants.authorization

    public init() {}
}
