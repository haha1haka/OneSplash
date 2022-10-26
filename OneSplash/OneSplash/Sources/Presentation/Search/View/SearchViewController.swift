import UIKit

class SearchViewContoller: BaseViewController {
    
    let selfView = SearchView()
    
    override func loadView() {
        view  = selfView
    }
    
    lazy var searchResultViewController = SearchResultViewController()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.placeholder = "Search photos, collections, users"
        searchController.searchBar.tintColor = .label
        searchController.searchResultsUpdater = searchResultViewController as? UISearchResultsUpdating
        searchController.delegate = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    override func configureInit() {
        navigationItem.searchController = searchController
        print("SearchViewController")
    }

}

extension SearchViewContoller: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.scopeButtonTitles = ["Photos", "Collections", "Users"]
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.scopeButtonTitles = nil
    }
}

extension SearchViewContoller: UISearchBarDelegate {
    
    
    // 그냥 서치바 클릭시 최초 1회
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("🟩")
    }
    
    
    // 엔터 버튼 클릭시
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("♥️")
    }
    
    
    
    // 캔슬 버튼 클릭시
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("⚠️")
        
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
