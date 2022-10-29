import UIKit
import SnapKit

class PhotoDetailViewController: BaseViewController {
    
    let selfView = PhotoDetailView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, USPhoto>!
    
    let viewModel = PhotoDetailViewModel()
    
    // 뷰모델로 해보기
    var currentPhotoItemIndex: Int?
    
    var roundButton: UIButton!
    
    override func loadView() { view = selfView }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = .green
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"ic_add_white_2x"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            roundButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
//            roundButton.widthAnchor.constraint(equalToConstant: 60),
//            roundButton.heightAnchor.constraint(equalToConstant: 60)
//        ])
        roundButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.bottom.equalTo(selfView.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(selfView.safeAreaLayoutGuide).inset(10)
        }
        
        
        
    }
    
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
        
        
        
        
        
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(ButtonClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(self.roundButton)

        
        
        

        

        
        
        
        
        
    }
    @objc
    func ButtonClick() {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.
        print("")
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
