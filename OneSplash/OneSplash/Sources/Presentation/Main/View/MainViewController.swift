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
    typealias CellRegistration = UICollectionView.CellRegistration<TopicCell, SectionItem>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    
    var dataSource: Datasource!
    var topicDataStore = [USTopic]()
    
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
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteSections(["Topics"])
            snapshot.appendSections(["Topics"])
            snapshot.appendItems(topics.map(SectionItem.topic))
            self.dataSource.apply(snapshot)
        }
        
//        UnsplashService.shared.requestTopics{ [weak self] topics in
//
//            guard let self = self else { return }
//
//            self.topicDataStore = topics
//
//            print(self.topicDataStore)
//
//
//        } onFailure: { [weak self] usError in
//            guard let self = self else { return }
//            print(usError.errors.first!)
//        }
        
        //UnsplashService.shared.requestTopicPhoto(from: <#T##USTopic#>, onSuccess: <#T##(([USTopicPhoto]) -> Void)##(([USTopicPhoto]) -> Void)##([USTopicPhoto]) -> Void#>)

    }
}




extension MainViewController {
    
    func configureCollectionViewDataSource() {
        dataSource = makeCellDataSource()
        dataSource.supplementaryViewProvider = makeSupplementaryViewDataSource()
    }
    
//    func applySnapShot() {
//        var snapshot = dataSource.snapshot()
//        snapshot.appendSections(["Topics"])
//        snapshot.appendItems(viewModel.topicDataStore.value, toSection: "Topics")
//        dataSource.apply(snapshot)
//    }
    
}

extension MainViewController {
    func makeCellDataSource() -> Datasource {
        let cellRegistration = CellRegistration { cell, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .topic(let itemIdentifier):
                cell.configureAttributes(with: itemIdentifier )
            default:
                print("")
            }
            
        }
        
        return Datasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    
    
    
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
