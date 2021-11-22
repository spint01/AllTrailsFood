//
//  ListViewController.swift
//  AllTrailsFood
//
//  Created by Steven G Pint on 11/17/21.
//

import UIKit

final class ListViewController: UIViewController {

    typealias PlaceDataSource = UICollectionViewDiffableDataSource<PlaceSection, RowItem>
    typealias PlaceSnapshot = NSDiffableDataSourceSnapshot<PlaceSection, RowItem>

    enum PlaceSection {
        case business
    }

    enum RowItemType {
        case place(Place)
    }

    struct RowItem: Hashable {
        let itemType: RowItemType
        let identifier: String

        init?(itemType: RowItemType, identifier: String?) {
            guard let identifier = identifier else { return nil }
            self.itemType = itemType
            self.identifier = identifier
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: RowItem, rhs: RowItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    private var collectionView: UICollectionView?
    private var dataSource: PlaceDataSource?
    var placeData: [Place]? {
        didSet {
            loadData()
        }
    }

    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: setup

    private func setupUI() {
        setupCollectionView()
        guard let collectionView = collectionView else { return }
        collectionView.backgroundColor = .atGray
        collectionView.insertAndPinToParentView(view)

        configureDataSource()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(102))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(102))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 20, bottom: 40, trailing: 20)
            section.interGroupSpacing = 12

            return section
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.registerCellClass(PlaceCollectionViewCell.self)

        self.collectionView = collectionView
    }

    // MARK: data handling

    private func configureDataSource() {
        guard let collectionView = collectionView else { return }
        dataSource = PlaceDataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, rowItem) -> UICollectionViewCell? in
            guard let _ = self else { return nil }
            switch rowItem.itemType {
            case let .place(place):
                let cell: PlaceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                let viewModel = PlaceViewModel(place: place)
                cell.configure(with: viewModel)

                return cell
            }
        }
    }

    private func loadData() {
        var snapshot = dataSource?.snapshot() ?? PlaceSnapshot()
        // remove previous data
        snapshot.deleteAllItems()

        defer {
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
        snapshot.appendSections([.business])
        snapshot.appendItems(buildRows())
    }

    private func buildRows() -> [RowItem] {
        guard let data = placeData else { return [] }

        return data.compactMap { RowItem(itemType: .place($0), identifier: $0.id) }
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource, let rowItem = dataSource.itemIdentifier(for: indexPath) else { return }
        switch rowItem.itemType {
        case let .place(place):
            let ctr = DetailViewController()
            navigationController?.pushViewController(ctr, animated: true)
            ctr.viewModel = PlaceViewModel(place: place)
        }
    }
}

