import UIKit


class PhotoDetailViewController: BaseViewController {
    
    let selfView = PhotoDetailView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, USPhoto>!
    
    let viewModel = PhotoDetailViewModel()
    
    
    
    // ⭐️ 뷰모델로 해보기
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
        
        selfView.floatingButton.addTarget(self, action: #selector(saveButtonClicked), for: UIControl.Event.touchUpInside)
        
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
        
        //print("🌞\(selfView.pageIndex)")
        guard let photos = viewModel.PhotosDataStore.value else { return }
        guard let pageIndex = selfView.pageIndex else { return }
        
        
        //⭐️ 질문하기
        let currentUSItem = photos[pageIndex]
        let currenItem = Photo(id: currentUSItem.id, url: currentUSItem.urls.regular, like: false)
        var downloadedImage: UIImage?
        let imageUrl = URL(string: currenItem.url)

        
        viewModel.createPhoto(item: currenItem)
        
        //⭐️ 킹피셔 개선
        URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
            guard let data = data, error == nil else { return }

            //⭐️ 이미지를 저장 하는게 좋은지, 데이터를 저장해서 다져올때 kf 로 변환 하는게 좋은지? 잭
            DispatchQueue.main.async() {
                downloadedImage = UIImage(data: data)
                //⭐️ 개선 해보기
                DocumentManager.shared.saveImageToDocument(fileName: currenItem.id, image: downloadedImage ?? UIImage(systemName: "exclamationmark.triangle.fill")!)
            }
        }.resume()

        
        
        
        

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
