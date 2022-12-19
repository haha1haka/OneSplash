import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    
    var topicDataStore = BehaviorSubject<[USTopic]>(value: [])
    var topicPhotosDataStore = BehaviorSubject<[USPhoto]>(value: [])
    
    let disposeBag = DisposeBag()
    
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

//    func requestRxTopic() {
//        let api = UnsplashRouter.topics
//        Observable.from(["d"])
//            .map { query1 -> URLComponents in
//                var urlComponents = URLComponents(string: UnsplashRouter.baseURL)!
//                urlComponents.query = api.path
//                urlComponents.queryItems = api.queryItems
//                return urlComponents
//            }
//            .map { urlComponents -> URLRequest in
//                var request = URLRequest(url: urlComponents?.path)
//                request.httpMethod = api.httpMethod.rawValue.uppercased()
//                request.allHTTPHeaderFields = api.headers
//                return request
//            }
//            .flatMap { urlRequest -> Observable<(response: HTTPURLResponse, data: Data)> in
//                return URLSession.shared.rx.response(request: urlRequest)
//            }
//            .filter { response, _ in
//                return 200..<300 ~= response.statusCode
//            }
//            .map { _, data -> [[String: Any]] in
//                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
//                      let result = json as? [[String: Any]] else { return [] }
//                return result
//            }
//            .filter { result in
//                return result.count > 0
//            }
//            .map { objects in
//                return objects.compactMap { dic -> USTopic? in
//                    guard let id = dic["id"] as? String,
//                          let title = dic["title"] as? String else { return }
//                    return USTopic(id: id, title: title)
//                }
//            }
//            .subscribe(onNext: { [weak self] topic in
//                guard let self = self else { return }
//                self.topicDataStore.onNext(topic)
//
//            })
//            .disposed(by: disposeBag)
//    }
