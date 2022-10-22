import UIKit

enum Section: Int, CaseIterable {
    case topic, pictures
    
    var columnCount: Int {
        switch self {
        case .topic:
            return 1
        case .pictures:
            return 2
        }
    }
    
}

class MainViewController: BaseViewController {
    
    
    
    let selfView = MainView()
    
    override func loadView() {
        view = selfView
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    typealias CellRegistration = UICollectionView.CellRegistration<MainCell, String>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    
    var dataSource: Datasource!
    var topicDataStore = [USTopic]()
    
    override func configureInit() {
        configureCollectionViewDataSource()
        applySnapShot()
    }
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UnsplashService.shared.requestTopics { [weak self] topics in
            
            guard let self = self else { return }
            
            self.topicDataStore = topics
        
            print(self.topicDataStore)
            
            
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            print(error)
        }

    }
}




extension MainViewController {
    
    func configureCollectionViewDataSource() {
        dataSource = makeCellDataSource()
        dataSource.supplementaryViewProvider = makeSupplementaryViewDataSource()
    }
    
    func applySnapShot() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0, 1])
        snapshot.appendItems(["안녕", "하세요", "fdsfsd"], toSection: 0)
        snapshot.appendItems(["sadf", "asdfs", "sadfasdf"], toSection: 1)
        dataSource.apply(snapshot)
    }
    
}

extension MainViewController {
    func makeCellDataSource() -> Datasource {
        let cellRegistration = CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier.description)
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

