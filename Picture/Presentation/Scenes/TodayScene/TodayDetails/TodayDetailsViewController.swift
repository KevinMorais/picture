//
//  TodayDetailsViewController.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit
import Combine

final class TodayDetailsViewController: UIViewController, DestinationAnimatedCardProtocol {

    private enum SectionId: Int {
        case photos
        case statistics
    }

    private enum Constants {
        static let sectionsInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    }

    private let viewModel: any TodayDetailsViewModelProtocol
    private weak var coordinator: (any TodayCoordinatorDelegate)?
    private var subscriptions = Set<AnyCancellable>()

    private var photoContent: TodayDetailsViewModel.ViewState.PhotoContent?
    private var statisticsContent: TodayDetailsViewModel.ViewState.StatisticsContent?

    // MARK: - DestinationAnimatedCardProtocol

    let destinationAnimationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    init(viewModel: any TodayDetailsViewModelProtocol, coordinator: any TodayCoordinatorDelegate) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.bind(on: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Elements

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .background?.withAlphaComponent(0.9)
        button.tintColor = .gray
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.addTarget(self, action: #selector(self.didTapCloseButton), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createViewLayout())
        collectionView.register(TodayDetailsPhotoCollectionViewCell.self)
        collectionView.register(TodayDetailsStatisticsCollectionViewCell.self)
        collectionView.register(TodayDetailsStatisticsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.viewModel.event.send(.viewDidLoad)
    }

    private func bind(on viewModel: any TodayDetailsViewModelProtocol) {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { viewState in
                switch viewState {
                case .idle: break
                case .loading(let content):
                    self.photoContent = content
                    self.collectionView.reloadData()
                case .loadedPhotos(let content):
                    self.photoContent = content
                    self.collectionView.reloadData()
                case .loadedStatistics(let content):
                    self.statisticsContent = content
                    self.collectionView.reloadData()
                }
            }
            .store(in: &self.subscriptions)
    }

    @objc
    private func didTapCloseButton() {
        self.coordinator?.userDidTapDismiss()
    }
}

// MARK: - UICollectionViewLayout

private extension TodayDetailsViewController {

    private func createViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case SectionId.photos.rawValue:
                return self?.createPhotosSection()
            case SectionId.statistics.rawValue:
                return self?.createStatisticsSection()
            default:
                return nil
            }
        }
    }

    private func createPhotosSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = Constants.sectionsInsets
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func createStatisticsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = Constants.sectionsInsets
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: .mediumMargin, bottom: 0, trailing: -.mediumMargin)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
}

// MARK: - UICollectionViewDataSource

extension TodayDetailsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSections = self.photoContent != nil ? 1 : 0
        numberOfSections += self.statisticsContent != nil ? 1 : 0
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case SectionId.photos.rawValue:
            return self.photoContent?.cells.count ?? 0
        case SectionId.statistics.rawValue:
            return self.statisticsContent?.cells.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case SectionId.photos.rawValue:
            return self.getPhotoCell(collectionView, at: indexPath)
        case SectionId.statistics.rawValue:
            return self.getStatisticsCell(collectionView, at: indexPath)
        default:
            return .init()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, TodayDetailsStatisticsHeader.self, for: indexPath),
              let headerModel = self.statisticsContent?.header else {
            return .init()
        }
        header.configure(headerModel)
        return header
    }

    private func getPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(TodayDetailsPhotoCollectionViewCell.self, for: indexPath),
              let cellModel = self.photoContent?.cells[safe: indexPath.row] else {
            return .init()
        }
        cell.configure(cellModel)
        return cell
    }

    private func getStatisticsCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(TodayDetailsStatisticsCollectionViewCell.self, for: indexPath),
              let cellModel = self.statisticsContent?.cells[safe: indexPath.row] else {
            return .init()
        }
        cell.configure(cellModel)
        return cell
    }
}

// MARK: - Configure UI

private extension TodayDetailsViewController {

    private func configureUI() {
        self.view.backgroundColor = .background
        self.view.addSubview(self.destinationAnimationView)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.closeButton)

        NSLayoutConstraint.activate([
            self.destinationAnimationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.sectionsInsets.leading),
            self.destinationAnimationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.sectionsInsets.top),
            self.destinationAnimationView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.49),
            self.destinationAnimationView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.294),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.closeButton.heightAnchor.constraint(equalToConstant: 36),
            self.closeButton.widthAnchor.constraint(equalToConstant: 36),
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: .smallMargin),
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -.mediumMargin)
        ])
    }
}
