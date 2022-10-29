import UIKit


class PhotoDetailViewController: BaseViewController {
    
    let selfView = PhotoDetailView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, USPhoto>!
    
    let viewModel = PhotoDetailViewModel()
    
    // 뷰모델로 해보기
    var currentPhotoItemIndex: Int?
    
    override func loadView() { view = selfView }
    
    
}
// MARK: - LifeCycle
extension PhotoDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        
        viewModel.PhotosDataStore.bind { [weak self] photos in
            guard let self = self else { return }
            guard let photos = photos else { return }
            var snapshot = self.collectionViewDataSource.snapshot()
            if !snapshot.sectionIdentifiers.isEmpty {
                snapshot.deleteSections(["main"])
            }
            snapshot.appendSections(["main"])
            snapshot.appendItems(photos)
            self.collectionViewDataSource.apply(snapshot) { [weak self] in
                guard let self = self else { return }
                guard let currentPhotoItemIndex = self.currentPhotoItemIndex else { return }
                let indexPath = IndexPath(item: currentPhotoItemIndex, section: 0)
                self.selfView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
            
        }
    }
}

// MARK: - DataSource
extension PhotoDetailViewController {
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier, labelIsEmpty: true)
        }
        
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<String, USPhoto>(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
    }
}

extension PhotoDetailViewController {
    
}
extension PhotoDetailViewController {
    
}
