import Foundation

class MainViewModel { // 실질적 데이터 100 개, 데이터의 로직
    var topicDataStore: Observable<[USTopic]> = Observable([USTopic(id: "", title: "")])
    
    var topicPhotosDataStore: Observable<[USPhoto]> = Observable([USPhoto(id: "",
                                                                                   width: 3000,
                                                                                   height: 2000,
                                                                                   user: USUser(id: "", name: ""),
                                                                                   urls: USUrls(regular: "")
                                                                                  )])
    
    
    
    func requestTopic() {
        UnsplashService.shared.requestTopics { [weak self] topics in
            guard let self = self else { return }
            self.topicDataStore.value = topics
        } onFailure: { usError in
            print(usError.errors.first!)
        }
    }
    
    func requestTopicPhotos(form selectedTopic: USTopic) {
        UnsplashService.shared.requestTopicPhotos(from: selectedTopic) { [weak self] unTopicPhotos in
            guard let self = self else { return }
            self.topicPhotosDataStore.value = unTopicPhotos
            print("🤢  \(unTopicPhotos)")
        }
    }
    
}
