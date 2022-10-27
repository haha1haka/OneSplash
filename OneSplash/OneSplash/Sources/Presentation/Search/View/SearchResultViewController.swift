import UIKit

class SearchResultViewController: BaseViewController {
    
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
        applyShapShot()
    }
    
    
}

extension SearchResultViewController {
    
    
    func configureDataSource() {
        
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
    
    
    func applyShapShot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections(["🔥 Recent Search"])
        snapshot.appendItems(["1", "2","3", "4", "5"])
        dataSource.apply(snapshot)
    }
    
}

extension SearchResultViewController {
    
    
    
    
}
