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
        case topicPhoto(USTopicPhoto)
    }
    
    
    
    typealias Datasource = UICollectionViewDiffableDataSource<String, SectionItem>
    //typealias Snapshot = NSDiffableDataSourceSnapshot<String, SectionItem>
    typealias topicCellRegistration = UICollectionView.CellRegistration<TopicCell, SectionItem>
    typealias topicPhotoCellRegistration = UICollectionView.CellRegistration<TopicPhotoCell, SectionItem>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    
    var dataSource: Datasource!
    //var topicDataStore = [USTopic]()
    
    let viewModel = MainViewModel()
    
    override func configureInit() {
        configureCollectionViewDataSource()
        //applySnapShot()
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
    
    func configureCollectionViewDataSource() {
        
        let topicCellRegistration = UICollectionView.CellRegistration<TopicCell, USTopic> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        let topicPhotoCellRegistraion = UICollectionView.CellRegistration<TopicPhotoCell, USTopicPhoto> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        
        dataSource = Datasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .topic(let usTopic):
                let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: usTopic)
                return cell
            case .topicPhoto(let usTopicPhoto):
                let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: topicPhotoCellRegistraion, for: indexPath, item: usTopicPhoto)
                return cell
            }
        }
        
        
        dataSource.supplementaryViewProvider = makeSupplementaryViewDataSource()
        
    }
    
}

extension MainViewController {
//    func makeCellDataSource() -> Datasource {
//
//
//
//        let cellRegistration = topicCellRegistration { cell, indexPath, itemIdentifier in
//
//            switch itemIdentifier {
//            case .topic(let itemIdentifier):
//                cell.configureAttributes(with: itemIdentifier )
//            default:
//                print("")
//            }
//
//        }
//
//        return Datasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
//            let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        }
//    }
    
    
//    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: SectionItem) -> UICollectionViewCell {
//
//    }
    
    
    func makeSupplementaryViewDataSource() -> Datasource.SupplementaryViewProvider {
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
            viewModel.requestTopicPhotos(form: unTopic)

        case .topicPhoto(let unTopicPhoto):
            print("")
        default:
            break
        }
        
        
    }
}

//extension UICollectionView {
//    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath, item: SectionItem) -> T {
//        return dequeueConfiguredReusableCell(using: , for: <#T##IndexPath#>, item: <#T##Item?#>)
//    }
//
//}
