import UIKit


//⭐️ 연관값 달면 Hashable 해야함
// dataSource 에도 써야하고, 해당 타입을 view 에 넘겨줄때도 써야 해서 옵셔널로 한것
enum ScopeType: Hashable {
    case photos
    case collections
    
}


protocol SearchBarScopeIndexDelegate: AnyObject {
    func scopeIndex(_ viewController: SearchViewContoller, indexPath: Int)
}


class SearchViewContoller: BaseViewController {

    let selfView = SearchView()
    override func loadView() {
        view  = selfView
    }
    
    
    typealias NewSnapshot = NSDiffableDataSourceSnapshot<String, USPhoto>
    
    typealias USSearchDatasource = UICollectionViewDiffableDataSource<String, USPhoto>
    typealias USCollectionDatasource = UICollectionViewDiffableDataSource<String, USCollection>
    
    typealias PhotosCellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto>
    typealias CollectionsCellRegistration = UICollectionView.CellRegistration<CollectionCell, USCollection>
    
    
    var searchTypeDataSource: USSearchDatasource!
    var collectionTypeDataSource: USCollectionDatasource!
    
    let searchResultViewController = SearchResultViewController()
    
    lazy var searchController: UISearchController = {
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
        
        configurePhotoDataSource()
    }

}
extension SearchViewContoller {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
extension SearchViewContoller {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        viewModel.searchPhotosDataStrore.bind { [weak self] usSearch in
            guard let self = self else { return }
            guard let usSearch = usSearch else { return } //[USSearch]
            print("🧨\(usSearch)")
            
            var snapshot = NewSnapshot()
            snapshot.deleteSections(["Results"])
            snapshot.appendSections(["Results"])
            snapshot.appendItems(usSearch.results)
            self.searchTypeDataSource.apply(snapshot)
        }
        
        
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
        
        
    }
}

extension SearchViewContoller {
    
    
    func configurePhotoDataSource() {
        let photoCellRegistration = UICollectionView.CellRegistration<PhotoCell, USPhoto> { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }

        searchTypeDataSource = USSearchDatasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = self.selfView.collectionView.dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    func configureSearchDataSource() {
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
    }
    
    
    // 엔터 버튼 클릭시
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchController.searchBar.text else { return }
        searchController.showsSearchResultsController = false
        print("♥️")
        viewModel.requestSearchPhotos(query: "\(query)")
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
            viewModel.requestSearchCollectionsPhotos()
            selfView.scopeType = .collections
            
            selfView.collectionView.setCollectionViewLayout(selfView.collectionViewLayoutByScopeType(), animated: false)
            configureSearchDataSource()
            
            print(selectedScope)
        default:
            selfView.scopeType = .collections
            //레이아웃 바꾸고
            //데이터소스바꾸고
            //data apply
            
        }
    }

}

