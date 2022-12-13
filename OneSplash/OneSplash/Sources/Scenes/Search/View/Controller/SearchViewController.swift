import UIKit
import RxSwift
import RxCocoa


//⭐️ 연관값 달면 Hashable 해야함
// dataSource 에도 써야하고, 해당 타입을 view 에 넘겨줄때도 써야 해서 옵셔널로 한것
enum ScopeType: Hashable {
    case photos
    case collections
    
}


protocol SearchBarScopeIndexDelegate: AnyObject {
    func scopeIndex(_ viewController: SearchViewContoller, indexPath: Int)
}


final class SearchViewContoller: BaseViewController {

    private let selfView = SearchView()
    override func loadView() {
        view  = selfView
    }
    
    private let disposeBag = DisposeBag()
    
    typealias NewSnapshot = NSDiffableDataSourceSnapshot<String, USPhoto>
    
    typealias USSearchDatasource = UICollectionViewDiffableDataSource<String, USPhoto>
    typealias USCollectionDatasource = UICollectionViewDiffableDataSource<String, USCollection>
    
    typealias PhotosCellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto>
    typealias CollectionsCellRegistration = UICollectionView.CellRegistration<CollectionCell, USCollection>
    
    
    private var searchTypeDataSource: USSearchDatasource!
    private var collectionTypeDataSource: USCollectionDatasource!
    
    private let searchResultViewController = SearchResultViewController()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.placeholder = "Search photos, collections, users"
        searchController.searchBar.tintColor = .label
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = searchResultViewController as? UISearchResultsUpdating
        return searchController
    }()
    
    let viewModel = SearchViewModel()
    
    
    override func configureInit() {
        navigationItem.searchController = searchController
        print("SearchViewController")
        selfView.collectionView.delegate = self
        searchResultViewController.eventDelegate = self
        configurePhotoDataSource()
    }

}


extension SearchViewContoller {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSearchLog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.searchPhotosDataStrore
            .withUnretained(self)
            .bind(onNext: { vc, usSearch in

                var snapshot = NewSnapshot()
                snapshot.deleteSections(["Results"])
                snapshot.appendSections(["Results"])
                snapshot.appendItems(usSearch.results)
                vc.searchTypeDataSource.apply(snapshot)
                
            })
            .disposed(by: disposeBag)

        
        
        viewModel.searchCollectionsDataStore.bind { [weak self] usCollection in
            guard let self = self else { return }
            guard let usCollection = usCollection else { return }
            print("✅\(usCollection)")

            var snapshot = NSDiffableDataSourceSnapshot<String, USCollection>()
            snapshot.deleteSections(["Results"])
            snapshot.appendSections(["Results"])
            // 🟥🟥레이아웃 바꿔야함
            snapshot.appendItems([usCollection])
            self.collectionTypeDataSource.apply(snapshot)

        }
        
        //searchController.searchBar.rx.text.orEmpty
        //    .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        //    .bind { value in
        //        print("💰\(value)")
        //    }
        

        
        
        
    }
}

extension SearchViewContoller {
    
    
    private func configurePhotoDataSource() {
        let photoCellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }

        searchTypeDataSource = USSearchDatasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    private func configureSearchDataSource() {
        let collectionCellRegistration = UICollectionView.CellRegistration<CollectionCell, USCollection> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }

        collectionTypeDataSource = USCollectionDatasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: collectionCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
}


extension SearchViewContoller: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.scopeButtonTitles = ["Photos", "Collections", "Users"]
        searchController.searchBar.selectedScopeButtonIndex = .zero
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.scopeButtonTitles = nil
        

    }
}

extension SearchViewContoller: UISearchBarDelegate {
    
    
    // 그냥 서치바 클릭시 최초 1회 -> SearchResultVC 젤위로 올라옴
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.showsSearchResultsController = true
        print("🟩")
        // 패치 -> 데이터 뿌리기

        let fetchedList = viewModel.searchLogFetchedData.toArray()
        let itemList = fetchedList.map{ $0.text }
        var snapshot = self.searchResultViewController.dataSource.snapshot()
        snapshot.appendItems(itemList)
        self.searchResultViewController.dataSource.apply(snapshot)
        
        
//        viewModel.searchTextDataStore
//            .bind(onNext: {
//
//            })
//            .disposed(by: disposeBag)
        
        
    }
    
    
    // 엔터 버튼 클릭시
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else { return }
        searchController.showsSearchResultsController = false
        print("♥️")
        viewModel.requestSearchPhotos(query: "\(searchText)")
        
        viewModel.saveToRepository(text: searchText)
    }
    

    // 캔슬 버튼 클릭시
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("⚠️")
        //cancel 눌렀을때 다시 지워주기
        var snapshot = searchTypeDataSource.snapshot()
        snapshot.deleteAllItems()
        searchTypeDataSource.apply(snapshot)
    }
    
    
    // scopeButton indexpath
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //⭐️근데 scopeButton 누를때마다 콜렉션뷰가 자시 만들어 져야 가능한 코드임 생각해보기
        switch selectedScope {
        case 0:
            selfView.scopeType = .photos
            configurePhotoDataSource()
            
            
            print(selectedScope)
        case 1:
            showAlert(message: "준비 중이예요!", completion: {})
            //viewModel.requestSearchCollectionsPhotos()
            //selfView.scopeType = .collections
            //selfView.collectionView.setCollectionViewLayout(selfView.collectionViewLayoutByScopeType(), animated: false)
            //configureSearchDataSource()
            
        default:
            showAlert(message: "준비 중이예요!", completion: {})
            //selfView.scopeType = .collections
            //레이아웃 바꾸고
            //데이터소스바꾸고
            //data apply
            
        }
    }

}

extension SearchViewContoller: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let photoDetailViewController = PhotoDetailViewController()
        
        //✅selected Item 의 index 넘겨서 다음 VC 의 viewdidload 에서 scrolltoItem
        photoDetailViewController.currentPhotoItemIndex = indexPath.item
        
        
        
        
        photoDetailViewController.viewModel.mainPhotosDataStore
            .onNext(try! viewModel.searchPhotosDataStrore.value().results)
            
        
        
        // = self.viewModel.searchPhotosDataStrore.value?.results
        
        
        transition(photoDetailViewController, transitionStyle: .push)

    }
}

extension SearchViewContoller: DidSelecteItemEvent {
    func searhedResultViewControllerIndexPath(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let selectedItemText = self.searchResultViewController.dataSource.itemIdentifier(for: indexPath) {
            viewModel.requestSearchPhotos(query: "\(selectedItemText)")
            searchController.showsSearchResultsController = false
        }
        
    }
}
