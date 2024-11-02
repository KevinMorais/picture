//
//  TodayDetailsPhotoCollectionViewCell.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit
import Combine
import PictureDesignKit

final class TodayDetailsPhotoCollectionViewCell: UICollectionViewCell {

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: TodayDetailsPhotoCollectionViewCellModel) {
        guard let imageURL = viewModel.imageURL else {
            self.imageView.backgroundColor = .tertiary
            return
        }
        self.imageView.backgroundColor = .clear
        self.imageView.set(url: imageURL, subscriptions: &self.subscriptions)
    }
}

// MARK: - UI

extension TodayDetailsPhotoCollectionViewCell {

    private func configureUI() {
        self.contentView.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
