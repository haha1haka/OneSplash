import UIKit


enum PhotoDetailType {
    case addPhoto
    case deletePhoto
}

final class PhotoDetailViewController: BaseViewController {
    
    private let selfView = PhotoDetailView()
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, USPhoto>!
    
    let viewModel = PhotoDetailViewModel()
    
    
    var photoDetailType = PhotoDetailType.addPhoto
    // ⭐️ 뷰모델로 해보기
    var currentPhotoItemIndex: Int?
    
    
    override func loadView() { view = selfView }
        
}

// MARK: - LifeCycle
extension PhotoDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        
//        viewModel.mainPhotosDataStore.bind { [weak self] photos in
//            guard let self = self else { return }
//            guard let photos = photos else { return }
//            var snapshot = self.collectionViewDataSource.snapshot()
//            if !snapshot.sectionIdentifiers.isEmpty {
//                snapshot.deleteSections(["main"])
//            }
//            snapshot.appendSections(["main"])
//            snapshot.appendItems(photos)
//            self.collectionViewDataSource.apply(snapshot) { [weak self] in
//                guard let self = self else { return }
//                guard let currentPhotoItemIndex = self.currentPhotoItemIndex else { return }
//                let indexPath = IndexPath(item: currentPhotoItemIndex, section: 0)
//                self.selfView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            }
//
//        }
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch photoDetailType {
        case .addPhoto:
            selfView.floatingButton.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
        case .deletePhoto:
            selfView.floatingButton.setImage(UIImage(systemName: "trash"), for: .normal)
        }
    }
}




// MARK: - addTargetMethod
extension PhotoDetailViewController {
    /*
     - 받아온 pageIndex 이용해서 id 값 접근 --> 램에 저장 하기
     -
     */
    @objc
    func saveButtonClicked() {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        //print("🌞\(selfView.pageIndex)")
        
        guard let photos = try? viewModel.mainPhotosDataStore.value() else { return }
        guard let pageIndex = selfView.pageIndex else { return }
        
        
        //⭐️ 질문하기 잭
        let currentUSItem = photos[pageIndex]
        
        var downloadedImage: UIImage?
        

        
        viewModel.createPhoto(item: currentUSItem)
        
        let imageUrl = URL(string: currentUSItem.urls?.regular ?? "")
        
        URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
            guard let data = data, error == nil else { return }
    
            DispatchQueue.main.async() {
                
                downloadedImage = UIImage(data: data)
                
                DocumentManager.shared.saveImageToDocument(fileName:currentUSItem.id,
                                                           image: downloadedImage ??
                                                                  UIImage(systemName: "exclamationmark.triangle.fill")!)
            }
        }.resume()

        

    }
}






// MARK: - DataSource
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

extension PhotoDetailViewController {
    
}
extension PhotoDetailViewController {
    
}
