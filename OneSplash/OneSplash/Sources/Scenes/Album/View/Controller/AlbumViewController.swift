import UIKit

class AlbumViewController: BaseViewController {
    
    let selfView = AlbumView()
    override func loadView() {
        view  = selfView
    }
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func configureInit() {
        configureCollectionViewDataSource()
        applySnapshot()
    }
}


extension AlbumViewController {
    
    func configureCollectionViewDataSource() {
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,String> { cell, indexPath, itemIdentifier in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
        }
        
        
        let CellRegistration = UICollectionView.CellRegistration<PhotoCell,String> { cell, indexPath, itemIdentifier in
            
        }
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: selfView.collectionView) {
            collectionView, indexPath, itemIdentifier in
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration, for: indexPath, item: itemIdentifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: CellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
        
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["저장한 사진", "1", "2", "3"])
        collectionViewDataSource.apply(snapshot)
        
    }
}
