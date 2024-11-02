//
//  TodayCollectionViewCell.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit
import Combine
import PictureDesignKit

final class TodayCollectionViewCell: UICollectionViewCell {

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .largeRadius
        return imageView
    }()

    private let titleLabel: MediumTitleLabel = {
        let label = MediumTitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .fixedWhite
        label.numberOfLines = 0
        return label
    }()

    private let userLabel: SmallTitleLabel = {
        let label = SmallTitleLabel()
        label.textColor = .fixedWhite
        return label
    }()

    private let likesLabel: SmallTitleLabel = {
        let label = SmallTitleLabel()
        label.textColor = .fixedWhite
        return label
    }()

    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var bottomStackView: UIStackView = {
        let rightVerticalStackView = UIStackView(arrangedSubviews: [
            self.userLabel,
            self.likesLabel
        ])
        rightVerticalStackView.axis = .vertical

        let bottomStackView = UIStackView(arrangedSubviews: [
            self.userImage,
            rightVerticalStackView
        ])
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 8
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        return bottomStackView
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

    func configure(_ viewModel: TodayCollectionViewCellModel) {
        self.titleLabel.text = viewModel.title
        self.userLabel.text = viewModel.userInfo.title
        self.likesLabel.text = viewModel.userInfo.numberOfLikes
        self.userImage.set(url: viewModel.userInfo.imageURL, subscriptions: &self.subscriptions)
        self.imageView.set(url: viewModel.imageURL, subscriptions: &self.subscriptions)
    }

    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        let imageViewSnapshot = self.imageView.snapshotView(afterScreenUpdates: afterUpdates)
        return imageViewSnapshot
    }

}

// MARK: - Configure UI

private extension TodayCollectionViewCell {

    private func configureUI() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.bottomStackView)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: .mediumMargin),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .mediumMargin),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -.mediumMargin),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.bottomStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .mediumMargin),
            self.bottomStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.bottomStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -.mediumMargin),
            self.userImage.widthAnchor.constraint(equalToConstant: 40),
            self.userImage.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.layer.cornerRadius = .largeRadius
        self.layer.masksToBounds = false
        self.userImage.layer.borderColor = UIColor.background?.cgColor
        self.userImage.layer.borderWidth = 2
        self.userImage.layer.cornerRadius = 20
        self.addShadow()
    }

    private func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10
    }
}
