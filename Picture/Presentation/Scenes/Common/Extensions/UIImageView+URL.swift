//
//  UIImageView+URL.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import UIKit
import PictureNetwork
import Combine

extension UIImageView {

    private static var _url: [String: String] = [:]

    private var url: String? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIImageView._url[tmpAddress] ?? nil
        }
        set {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIImageView._url[tmpAddress] = newValue
        }
    }

    enum Constants {
        fileprivate static let failedImage: UIImage? = .init(systemName: "exclamationmark.circle")
        fileprivate static let api: some APIClientProtocol = APIClient()
    }

    public func set(url: URL?, subscriptions: inout Set<AnyCancellable>) {

        guard url?.absoluteString != self.url else {
            return
        }
        guard let url = url else {
            return
        }
        self.addActivityIndicator()
        self.backgroundColor = .tertiary
        Constants.api.get(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.image = Constants.failedImage
                }
                self?.removeActivityIndicator()
            }, receiveValue: { [weak self] data in
                self?.image = UIImage(data: data) ?? Constants.failedImage
                self?.backgroundColor = .clear
            })
            .store(in: &subscriptions)
    }

    private func addActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        image = nil
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }

    private func removeActivityIndicator() {
        subviews.first(where: { $0 is UIActivityIndicatorView })?.removeFromSuperview()
    }

}
