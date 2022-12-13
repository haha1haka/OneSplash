import UIKit
import Kingfisher

final class AlbumViewController: BaseViewController {
    
    let selfView = AlbumView()
    override func loadView() {
        view  = selfView
    }
    private let viewModel = AlbumViewModel()
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, USPhoto>!
    
    override func configureInit() {
        
        navigationItem.title = "Album 🖼"
        
        configureCollectionViewDataSource()
        selfView.collectionView.delegate = self
        
        viewModel.albumPhotoDataStore.bind { [weak self] photoList in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, USPhoto>()
            
            snapshot.appendSections([0])
            snapshot.appendItems(photoList)
            self.collectionViewDataSource.apply(snapshot)
        }
    }
}
extension AlbumViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        viewModel.fetchPhoto()
        

    }
}


extension AlbumViewController {
    
    private func configureCollectionViewDataSource() {
        
        
        let CellRegistration = UICollectionView.CellRegistration<PhotoCell,USPhoto> { cell, indexPath, itemIdentifier in
            let imageUrl = URL(string: itemIdentifier.urls?.regular ?? "")
            cell.imageView.kf.setImage(with: imageUrl)
        }
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<Int, USPhoto>(collectionView: selfView.collectionView) {
            collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: CellRegistration, for: indexPath, item: itemIdentifier)
            return cell
            
        }
        
    }

    private func applySnapshot() {

        
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        var selectedItem = collectionViewDataSource.itemIdentifier(for: indexPath)
        
        let photoDetailViewController = PhotoDetailViewController()
        
        
        photoDetailViewController.currentPhotoItemIndex = indexPath.item
        
        photoDetailViewController.photoDetailType = .deletePhoto
        
        photoDetailViewController.viewModel.mainPhotosDataStore
            .onNext(try! viewModel.albumPhotoDataStore.value())
            
            
            //.value = self.viewModel.albumPhotoDataStore.value
        
        
        transition(photoDetailViewController, transitionStyle: .push)
        
    }
}
