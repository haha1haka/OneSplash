import UIKit

//enum Section: Int, CaseIterable {
//    case topic, pictures
//
//    var columnCount: Int {
//        switch self {
//        case .topic:
//            return 1
//        case .pictures:
//            return 2
//        }
//    }
//
//}

class MainViewController: BaseViewController {
    
    let selfView = MainView()
    
    override func loadView() {
        view = selfView
    }
    
    enum SectionItem: Hashable {
        case topic(USTopic)
        case topicPhoto(USPhoto)
    }
    
    
    
    typealias Datasource = UICollectionViewDiffableDataSource<String, SectionItem>
    typealias topicCellRegistration = UICollectionView.CellRegistration<TopicCell, USTopic>
    typealias topicPhotoCellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    
    var dataSource: Datasource!
    
    
    let viewModel = MainViewModel()
    
    override func configureInit() {
        configureCollectionViewDataSource()
        
    }
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        selfView.collectionView.delegate = self
        
        viewModel.requestTopic()
        
        viewModel.topicDataStore.bind { [weak self] topics in // [USTopic]
            print("🥶  \(topics)")
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<String, SectionItem>()
            snapshot.appendSections(["Topics"])
            snapshot.appendItems(topics.map(SectionItem.topic))
            self.dataSource.apply(snapshot)
        }
        
        
        viewModel.topicPhotosDataStore.bind { [weak self] topicPhotos in
            guard let self = self else { return }
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteSections(["Topic'sPhotos"])
            snapshot.appendSections(["Topic'sPhotos"])
            snapshot.appendItems(topicPhotos.map(SectionItem.topicPhoto))
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        
        
    }
}




extension MainViewController {
    
    func configureCollectionViewDataSource(){
        dataSource = configureCellDataSource()
        dataSource.supplementaryViewProvider = configureSupplementaryItemDataSource()
    }
}

extension MainViewController {
    
    func configureCellDataSource() -> Datasource {
        
        let topicCellRegistration = topicCellRegistration { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        let topicPhotoCellRegistraion = topicPhotoCellRegistration { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        
        return Datasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .topic(let usTopic):
                let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: usTopic)
                return cell
            case .topicPhoto(let usTopicPhoto):
                let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: topicPhotoCellRegistraion, for: indexPath, item: usTopicPhoto)
                return cell
            }
        }
    }
    
    func configureSupplementaryItemDataSource() -> Datasource.SupplementaryViewProvider {
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            guard let sectionIdentifier = self.dataSource.sectionIdentifier(for: indexPath.section) else { return }
            supplementaryView.titleLabel.text = sectionIdentifier.description
        }
        return { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
    }
}






extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sectionItem = dataSource.itemIdentifier(for: indexPath)
        
        switch sectionItem {
            
        case .topic(let unTopic):
            return viewModel.requestTopicPhotos(form: unTopic)
            
        case .topicPhoto( _):
            let photoDetailViewController = PhotoDetailViewController()
            
            //✅selected Item 의 index 넘겨서 다음 VC 의 viewdidload 에서 scrolltoItem 
            photoDetailViewController.currentPhotoItemIndex = indexPath.item
            
            photoDetailViewController.viewModel.PhotosDataStore.value = self.viewModel.topicPhotosDataStore.value
            
            
            transition(photoDetailViewController, transitionStyle: .push)
            
        default:
            print("")
            
            
        }
    }
}
