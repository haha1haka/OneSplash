import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    
    var searchPhotosDataStrore = BehaviorSubject<USSearch>(value: USSearch(total: 0, totalPages: 0, results: []))
    var searchCollectionsDataStore: Observable<USCollection?> = Observable(nil)
    
    
    
    
    func requestSearchPhotos(query: String) {
        UnsplashService.shared.requestSearchPhotos(query: query) { [weak self] usSearch in
            guard let self = self else { return }
            self.searchPhotosDataStrore
                .onNext(usSearch)
            //print("📕  \(usSearch.results)")
        }
    }
    
    func requestSearchCollectionsPhotos() {
        UnsplashService.shared.requestSearchCollections { [weak self] usColletion in
            guard let self = self else { return }
            self.searchCollectionsDataStore.value = usColletion
            print("😈😈\(usColletion)")
        }
    }
    
    
    
    
    
}
