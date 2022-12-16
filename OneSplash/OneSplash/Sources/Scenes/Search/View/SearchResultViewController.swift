import UIKit
import RxSwift
import RxCocoa



protocol DidSelecteItemEvent {
    func searhedResultViewControllerIndexPath(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}


final class SearchResultViewController: BaseViewController {
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    let selfView = SearchResultView()
    override func loadView() {
        view = selfView
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<String, String>
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SearchResultHeaderView>
    
    
    var dataSource: Datasource!
    var eventDelegate: DidSelecteItemEvent?
    
    override func configureInit() {
        configureDataSource()
        applyInitSnapShot()
        selfView.collectionView.delegate = self
    }
    
    
}

extension SearchResultViewController {
    
    
    private func configureDataSource() {
        
        let listCellRegistration = ListCellRegistration { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.image = UIImage(systemName: "magnifyingglass")
            configuration.text = itemIdentifier
            configuration.imageProperties.tintColor = .secondaryLabel
            cell.contentConfiguration = configuration
        }
        
        dataSource = Datasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        
        
        
//        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
//            guard let sectionIdentifier = self.dataSource.sectionIdentifier(for: indexPath.section) else { return }
//            var configuration = UIListContentConfiguration.sidebarHeader()
//            configuration.text = sectionIdentifier.description
//
//            supplementaryView.contentConfiguration = configuration
//        }
        
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            guard let sectionIdentifier = self.dataSource.sectionIdentifier(for: indexPath.section) else { return }
            supplementaryView.titleLabel.text = sectionIdentifier
            
            supplementaryView.clearButton.rx.tap
                .bind(onNext: {
                    print("fasdfa")
                    
                    var snapshot = self.dataSource.snapshot()
                    let allItems = snapshot.itemIdentifiers(inSection: "🔥 Recent Search")
                    snapshot.deleteItems(allItems)
                    self.dataSource.apply(snapshot)

                    self.viewModel.deleteAllItemInRealm()
                })
                .disposed(by: self.disposeBag)
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

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.eventDelegate?.searhedResultViewControllerIndexPath(collectionView, didSelectItemAt: indexPath)
    }
}
