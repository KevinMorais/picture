//
//  TodayCollectionViewHeader.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit
import PictureDesignKit

final class TodayCollectionViewHeader: UICollectionReusableView {

    // MARK: - UI Elements

    private let dateLabel: MediumTitleLabel = {
        let label = MediumTitleLabel()
        return label
    }()

    private let titleLabel: LargeTitleLabel = {
        let label = LargeTitleLabel()
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.dateLabel,
            self.titleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 12
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

    func configure(_ viewModel: TodayCollectionViewHeaderModel) {
        self.dateLabel.text = viewModel.dateText
        self.titleLabel.text = viewModel.todayText
    }
}

// MARK: - Configure UI

private extension TodayCollectionViewHeader {

    private func configureUI() {
        self.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
