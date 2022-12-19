import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {
    
    typealias Datasource = UICollectionViewDiffableDataSource<String, SectionItem>
    typealias topicCellRegistration = UICollectionView.CellRegistration<TopicCell, USTopic>
    typealias topicPhotoCellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    
    private let selfView = MainView()
    
    override func loadView() { view = selfView }
    
    enum SectionItem: Hashable {
        case topic(USTopic)
        case topicPhoto(USPhoto)
    }
    
    private var dataSource: Datasource!
    let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func configureInit() {
        configureCollectionViewDataSource()
    }
}

extension MainViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "🎉 OneSplash"
        
        selfView.collectionView.delegate = self
        
        viewModel.requestTopic()
        
        viewModel.topicDataStore
            .withUnretained(self)
            .bind(onNext: { vc, ustopics in
            print("🥶  \(ustopics)")
            
            var snapshot = NSDiffableDataSourceSnapshot<String, SectionItem>()
            snapshot.appendSections(["Topics"])
            snapshot.appendItems(ustopics.map(SectionItem.topic))
            vc.dataSource.apply(snapshot)
        })
            .disposed(by: disposeBag)
            
        viewModel.topicPhotosDataStore
            .withUnretained(self)
            .bind(onNext: { vc, unTopicPhotos in
                var snapshot = self.dataSource.snapshot()
                
                if !snapshot.sectionIdentifiers.isEmpty {
                    snapshot.deleteSections(["Topic'sPhotos"])
                    snapshot.deleteItems(unTopicPhotos.map(SectionItem.topicPhoto))
                }
                snapshot.appendSections(["Topic'sPhotos"])
                snapshot.appendItems(unTopicPhotos.map(SectionItem.topicPhoto))
                vc.dataSource.apply(snapshot)

            })
            .disposed(by: disposeBag)
    }
}




extension MainViewController {
    private func configureCollectionViewDataSource() {
        dataSource = configureCellDataSource()
        dataSource.supplementaryViewProvider = configureSupplementaryItemDataSource()
    }
}

extension MainViewController {
    
    private func configureCellDataSource() -> Datasource {
        
        let topicCellRegistration = topicCellRegistration { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        
        let topicPhotoCellRegistraion = topicPhotoCellRegistration { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
            
        }
        
        return UICollectionViewDiffableDataSource<String, SectionItem>(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
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
    
    private func configureSupplementaryItemDataSource() -> Datasource.SupplementaryViewProvider {
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
        case .topic(let usTopic):
            return viewModel.requestTopicPhotos(from: usTopic)
        case .topicPhoto(_):
            let photoDetailViewController = PhotoDetailViewController()
            photoDetailViewController.currentPhotoItemIndex = indexPath.item
            photoDetailViewController.viewModel.currentIndex
                .onNext(indexPath.item)
            photoDetailViewController.viewModel.mainPhotosDataStore
                .onNext(try! viewModel.topicPhotosDataStore.value())
            transition(photoDetailViewController, transitionStyle: .push)
        default:
            return
        }
    }
}
