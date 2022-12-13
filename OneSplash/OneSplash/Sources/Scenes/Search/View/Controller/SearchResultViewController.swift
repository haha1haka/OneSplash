import UIKit

final class SearchResultViewController: BaseViewController {
    
    let selfView = SearchResultView()
    override func loadView() {
        view = selfView
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<String, String>
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>
    
    
    var dataSource: Datasource!
    
    override func configureInit() {
        configureDataSource()
        applyInitSnapShot()
    }
    
    
}

extension SearchResultViewController {
    
    
    private func configureDataSource() {
        
        let listCellRegistration = ListCellRegistration { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier
            cell.contentConfiguration = configuration
        }
        
        dataSource = Datasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            guard let sectionIdentifier = self.dataSource.sectionIdentifier(for: indexPath.section) else { return }
            var configuration = UIListContentConfiguration.sidebarHeader()
            configuration.text = sectionIdentifier.description
            supplementaryView.contentConfiguration = configuration
        }
        
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func applyInitSnapShot() {
        var snapshot = dataSource.snapshot()
            snapshot.appendSections(["🔥 Recent Search"])
            dataSource.apply(snapshot)
    }

    
}

extension SearchResultViewController {
    
    
    
    
}
