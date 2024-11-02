//
//  TodayViewController.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import Foundation
import Combine
import UIKit

final class TodayViewController: UIViewController, SourceAnimatedCardProtocol {

    private let viewModel: any TodayViewModelProtocol
    private weak var coordinator: (any TodayCoordinatorDelegate)?
    private var subscriptions = Set<AnyCancellable>()

    private var loadedContent: TodayViewModel.ViewState.Loaded?
    private var loadingContent: TodayViewModel.ViewState.Loading?

    // MARK: - SourceAnimatedCardProtocol
    var sourceAnimationView: UIView?

    init(viewModel: any TodayViewModelProtocol, coordinator: any TodayCoordinatorDelegate) {
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
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createViewLayout())
        collectionView.register(TodayCollectionViewCell.self)
        collectionView.register(TodayCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.viewModel.event.send(.viewDidLoad)
    }

    // MARK: - Binding

    private func bind(on viewModel: any TodayViewModelProtocol) {
        viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                switch viewState {
                case .idle:
                    break
                case .loading(let content):
                    self?.loadingContent = content
                    self?.collectionView.reloadData()
                    self?.loadedContent = nil
                case .loaded(let content):
                    self?.loadedContent = content
                    self?.collectionView.reloadData()
                case .selected(let photo):
                    self?.coordinator?.userDidTapOnCard(photo)
                }
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - UICollectionViewLayout

private extension TodayViewController {

    private func createViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self else { return nil }
            let section = self.createTodaySection()
            section.boundarySupplementaryItems = [self.createHeader()]
            return section
        }
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        return .init(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }

    private func createTodaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: .smallMargin, leading: .mediumMargin, bottom: 20, trailing: .mediumMargin)
        section.interGroupSpacing = 20

        return section
    }
}

// MARK: - UICollectionViewDataSource

extension TodayViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.loadedContent != nil ? 1 : 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.loadedContent?.cells.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(TodayCollectionViewCell.self, for: indexPath),
              let cellModel = self.loadedContent?.cells[safe: indexPath.row] else {
            return .init()
        }
        cell.configure(cellModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, TodayCollectionViewHeader.self, for: indexPath),
              let headerModel = self.loadingContent?.header else {
            return .init()
        }
        header.configure(headerModel)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension TodayViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.sourceAnimationView = collectionView.cellForItem(at: indexPath)
        self.viewModel.event.send(.selectItem(index: indexPath.row))
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            collectionView.cellForItem(at: indexPath)?.transform = .init(scaleX: 0.95, y: 0.95)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            collectionView.cellForItem(at: indexPath)?.transform = .identity
        }
    }
}

private extension TodayViewController {

    private func configureUI() {
        self.view.backgroundColor = .background
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
