import UIKit

class SearchViewContoller: BaseViewController {

    let selfView = SearchView()
    override func loadView() {
        view  = selfView
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<String, USPhoto>
    typealias NewSnapshot = NSDiffableDataSourceSnapshot<String, USPhoto>
    typealias SearchCellRegistraion = UICollectionView.CellRegistration<PhotoCell, USPhoto>
    
    var dataSource: Datasource!
    
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
        configureDataSource()
        
    }

}
extension SearchViewContoller {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        var newSnapshot = dataSource.snapshot()
//        newSnapshot.deleteAllItems()
//        dataSource.apply(newSnapshot)
    }
}
extension SearchViewContoller {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        viewModel.searchPhotosDataStrore.bind { [weak self] usSearch in
            guard let self = self else { return }
            guard let usSearch = usSearch else { return }
            print("🧨\(usSearch)")
            
            var snapshot = NewSnapshot()
            snapshot.deleteSections(["Results"])
            snapshot.appendSections(["Results"])
            snapshot.appendItems(usSearch.results)
            self.dataSource.apply(snapshot)
        }
        
        
    }
}

extension SearchViewContoller {
    
    func configureDataSource() {
        
        let searchCellRegistration = SearchCellRegistraion { cell, indexPath, itemIdentifier in
            cell.configureAttributes(with: itemIdentifier)
        }
        
        dataSource = Datasource(collectionView: selfView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: searchCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }

    }
    
    
//    func applyShapShot() {
//        var snapshot = dataSource.snapshot()
//        snapshot.appendSections(["🔥 Recent Search"])
//        snapshot.appendItems(["1", "2","3", "4", "5"])
//        dataSource.apply(snapshot)
//    }
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
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot)
        
        
        
        
        
    }
    
    
    // scopeButton indexpath
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            print(selectedScope)
        case 1:
            print(selectedScope)
        default:
            print(selectedScope)
            
        }
    }

}

