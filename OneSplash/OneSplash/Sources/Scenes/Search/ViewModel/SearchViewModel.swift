import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    
    var searchPhotosDataStrore = BehaviorSubject<USSearch>(value: USSearch(total: 0, totalPages: 0, results: []))
    var searchCollectionsDataStore: Observable<USCollection?> = Observable(nil)
    
    
    
    
    
    
    func requestSearchPhotos(query: String) {
        let api = UnsplashRouter.search(query: query)
        UnsplashService.shared.request(type: USSearch.self, path: api.path, queryItems: api.queryItems, httpMethod: api.httpMethod, headers: api.headers) { [weak self] searchPhotos in
            switch searchPhotos {
            case .success(let data):
                self?.searchPhotosDataStrore.onNext(data)
            case .failure:
                return
            }
        }
    }
    
    
    
    
    
    
    
    
    func requestSearchCollectionsPhotos() {
//        UnsplashService.shared.requestSearchCollections { [weak self] usColletion in
//            guard let self = self else { return }
//            self.searchCollectionsDataStore.value = usColletion
//            print("😈😈\(usColletion)")
//        }
    }
    
    
    
    
    
}
