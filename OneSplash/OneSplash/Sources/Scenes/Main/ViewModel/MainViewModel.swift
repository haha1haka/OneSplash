import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    var topicDataStore = PublishSubject<[USTopic]>()
    
    
    var topicPhotosDataStore = BehaviorSubject<[USPhoto]>(value: [])
    
    
    func requestTopic() {
        UnsplashService.shared.requestTopics { [weak self] topics in //[USTopic]
            guard let self = self else { return }
            self.topicDataStore.onNext(topics)
        } onFailure: { usError in
            print(usError.errors.first!)
        }
    }
    
    func requestTopicPhotos(form selectedTopic: USTopic) {
        UnsplashService.shared.requestTopicPhotos(from: selectedTopic) { [weak self] unTopicPhotos in
            guard let self = self else { return }
            self.topicPhotosDataStore.onNext(unTopicPhotos)
            print("🤢  \(unTopicPhotos)")
        }
    }
    
}
