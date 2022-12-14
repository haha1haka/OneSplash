import UIKit


enum PhotoDetailType {
    case addPhoto
    case deletePhoto
}

final class PhotoDetailViewController: BaseViewController {
    
    private let selfView = PhotoDetailView()
    
    override func loadView() { view = selfView }
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, USPhoto>!
    
    let viewModel = PhotoDetailViewModel()
    
    var photoDetailType = PhotoDetailType.addPhoto
    
    var currentPhotoItemIndex: Int?
}

extension PhotoDetailViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        switch photoDetailType {
        case .addPhoto:
            selfView.floatingButton.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
        case .deletePhoto:
            selfView.floatingButton.setImage(UIImage(systemName: "trash"), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        
        viewModel.mainPhotosDataStore
            .withUnretained(self)
            .bind(onNext: { vc, photos in
                var snapshot = self.collectionViewDataSource.snapshot()
                if !snapshot.sectionIdentifiers.isEmpty {
                    snapshot.deleteSections(["main"])
                }
                snapshot.appendSections(["main"])
                snapshot.appendItems(photos)
                vc.collectionViewDataSource.apply(snapshot) { [weak self] in
                    guard let self = self else { return }
                    guard let currentPhotoItemIndex = self.currentPhotoItemIndex else { return }
                    let indexPath = IndexPath(item: currentPhotoItemIndex, section: 0)
                    vc.selfView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                }
        })
        
        selfView.floatingButton.addTarget(self, action: #selector(saveButtonClicked), for: UIControl.Event.touchUpInside)
    }
}

extension PhotoDetailViewController {

    @objc
    func saveButtonClicked() {
        
        guard let photos = try? viewModel.mainPhotosDataStore.value() else { return }
        guard let pageIndex = selfView.pageIndex else { return }
        
        let currentUSItem = photos[pageIndex]
        
        var downloadedImage: UIImage?
    
        viewModel.createPhoto(item: currentUSItem)
        
        let imageUrl = URL(string: currentUSItem.urls?.regular ?? "")
        
        URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
            guard let data = data, error == nil else { return }
    
            DispatchQueue.main.async() {
                
                downloadedImage = UIImage(data: data)
                
                DocumentManager.shared.saveImageToDocument(
                    fileName:currentUSItem.id,
                    image: downloadedImage ??
                    UIImage(systemName: "exclamationmark.triangle.fill")!) {
                    self.showAlert(message: "????????? ?????? ??????")
                }
            }
        }.resume()
    }
}

extension PhotoDetailViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier, labelIsEmpty: true)
        }
        
        collectionViewDataSource = UICollectionViewDiffableDataSource<String, USPhoto>(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
    }
}
