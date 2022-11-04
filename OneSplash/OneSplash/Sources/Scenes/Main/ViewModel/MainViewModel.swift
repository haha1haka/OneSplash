import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    var topicDataStore = PublishSubject<[USTopic]>()
    var topicPhotosDataStore = BehaviorSubject<[USPhoto]>(value: [])
    

    
    func requestTopic() {
        let api = UnsplashRouter.topics
        UnsplashService.shared.request(type: [USTopic].self, path: api.path, queryItems: api.queryItems, httpMethod: api.httpMethod, headers: api.headers) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.topicDataStore.onNext(data)
            case .failure:
                return
            }
        }
    }
    
    
    func requestTopicPhotos(from selectedTopic: USTopic) {
        let api = UnsplashRouter.topicPhotos(id: selectedTopic.id)
        
        UnsplashService.shared.request(type: [USPhoto].self, path: api.path, queryItems: api.queryItems, httpMethod: api.httpMethod, headers: api.headers) { [weak self] topicPhotos in
            guard let self = self else { return }
            switch topicPhotos {
            case .success(let data):
                self.topicPhotosDataStore.onNext(data)
            case .failure:
                return
            }
        }
    }

    
}
