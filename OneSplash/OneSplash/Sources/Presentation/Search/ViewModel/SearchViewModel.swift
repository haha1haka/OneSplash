import Foundation

class SearchViewModel {
    var searchPhotosDataStrore: Observable<USSearch?> = Observable(nil)
    
    func requestSearchPhotos(query: String) {
        UnsplashService.shared.requestSearchPhotos(query: query) { [weak self] usSearch in
            guard let self = self else { return }
            self.searchPhotosDataStrore.value = usSearch // USSearch
            //print("📕  \(usSearch.results)")
        }
    }
    
    
}
