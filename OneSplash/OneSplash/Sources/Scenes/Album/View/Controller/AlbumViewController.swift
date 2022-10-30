import UIKit
import Kingfisher

class AlbumViewController: BaseViewController {
    
    let selfView = AlbumView()
    override func loadView() {
        view  = selfView
    }
    let viewModel = AlbumViewModel()
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, Photo>!
    
    override func configureInit() {
        configureCollectionViewDataSource()
        //applySnapshot()
    }
}
extension AlbumViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPhoto()
        
        viewModel.photoList.bind { [weak self] photoList in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
            let items = photoList
            snapshot.appendSections([0])
            snapshot.appendItems(items)
            self.collectionViewDataSource.apply(snapshot)
        }
    }
}


extension AlbumViewController {
    
    func configureCollectionViewDataSource() {
        
        
        let CellRegistration = UICollectionView.CellRegistration<PhotoCell,Photo> { cell, indexPath, itemIdentifier in
            let imageUrl = URL(string: itemIdentifier.url)
            cell.imageView.kf.setImage(with: imageUrl)
        }
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Int, Photo>(collectionView: selfView.collectionView) {
            collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: CellRegistration, for: indexPath, item: itemIdentifier)
            return cell
            
        }
        
    }

    func applySnapshot() {

        
    }
}
