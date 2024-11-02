//
//  TodayDetailsStatisticsHeader.swift
//  Picture
//
//  Created by Kevin Morais on 02/11/2024.
//

import Foundation

import UIKit
import PictureDesignKit

final class TodayDetailsStatisticsHeader: UICollectionReusableView {

    private let titleLabel: LargeTitleLabel = {
        let label = LargeTitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: TodayDetailsStatisticsHeaderModel) {
        self.titleLabel.text = viewModel.title
    }
}

// MARK: - Configure UI

private extension TodayDetailsStatisticsHeader {

    private func configureUI() {
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
