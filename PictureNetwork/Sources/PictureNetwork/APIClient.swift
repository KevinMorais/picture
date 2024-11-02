//
//  APIClient.swift
//
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine

public enum APIClientError: Error, Equatable {
    case unknown
    case emptyResponse
    case httpError(status: Int)

    public static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown):
            return true
        case (.emptyResponse, .emptyResponse):
            return true
        case (.httpError(let lhsStatus), (.httpError(let rhsStatus))):
            return lhsStatus == rhsStatus
        default:
            return false
        }
    }
}

public protocol APIClientProtocol {
    func get(path: String) -> AnyPublisher<Data, Error>
    func get(url: URL) -> AnyPublisher<Data, Error>
}

public class APIClient {

    private let urlSession: URLSession
    private let configuration: APIConfiguration

    public init(
        urlSession: URLSession = .shared,
        configuration: APIConfiguration = .init()
    ) {
        self.urlSession = urlSession
        self.configuration = configuration
    }

    private func dataTask(with url: URL) -> AnyPublisher<Data, Error> {

        let urlRequest = self.buildRequest(from: url)

        return self.urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { dataTask in
                guard let response = dataTask.response as? HTTPURLResponse else {
                    throw APIClientError.unknown
                }
                guard self.configuration.rangeSuccessCode.contains(response.statusCode) else {
                    throw APIClientError.httpError(status: response.statusCode)
                }
                guard !dataTask.data.isEmpty else {
                    throw APIClientError.emptyResponse
                }
                return dataTask.data
            }
            .eraseToAnyPublisher()
    }

    private func buildRequest(from url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(self.configuration.authorizationValue, forHTTPHeaderField: self.configuration.authorizationKey)
        return urlRequest
    }
}

// MARK: - APIClientProtocol

extension APIClient: APIClientProtocol {

    public func get(path: String) -> AnyPublisher<Data, Error> {
        let url = self.configuration.baseURL.appendingPathComponent(path)
        return self.dataTask(with: url)
    }

    public func get(url: URL) -> AnyPublisher<Data, Error> {
        return self.dataTask(with: url)
    }
}
