//
//  TodayDetailsStatisticsCollectionViewCell.swift
//  Picture
//
//  Created by Kevin Morais on 02/11/2024.
//

import UIKit
import PictureDesignKit

final class TodayDetailsStatisticsCollectionViewCell: UICollectionViewCell {

    // MARK: - LifeCycle

    private let leftImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let rightText: BodyLabel = {
        let label = BodyLabel()
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.leftImage,
            self.rightText
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = .smallMargin
        stackView.alignment = .center
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: TodayDetailsStatisticsCollectionViewCellModel) {
        self.leftImage.image = .init(named: viewModel.imageName)
        self.rightText.text = viewModel.text
    }
}

// MARK: - UI

extension TodayDetailsStatisticsCollectionViewCell {

    private func configureUI() {
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.leftImage.heightAnchor.constraint(equalToConstant: 24),
            self.leftImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
