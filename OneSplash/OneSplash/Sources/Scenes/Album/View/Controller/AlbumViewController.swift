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
        
        
        let CellRegistration = UICollectionView.CellRegistration<PhotoCell,String> { cell, indexPath, itemIdentifier in
            cell.label.text = itemIdentifier.description
        }
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: selfView.collectionView) {
            collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: CellRegistration, for: indexPath, item: itemIdentifier)
            return cell
            
        }
        
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(["1", "2", "3", "4", "5", "6", "7"])
        collectionViewDataSource.apply(snapshot)
        
    }
}
