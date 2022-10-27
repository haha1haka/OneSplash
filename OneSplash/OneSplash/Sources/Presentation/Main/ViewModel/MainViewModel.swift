import Foundation

class MainViewModel {
    var topicDataStore: Observable<[USTopic]> = Observable([USTopic(id: "", title: "")])
    
    var topicPhotosDataStore: Observable<[USPhoto]> = Observable([USPhoto(id: "",
                                                                                   width: 0,
                                                                                   height: 0,
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
