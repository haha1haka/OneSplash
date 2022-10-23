import Foundation

class MainViewModel {
    var topicDataStore: Observable<[USTopic]> = Observable([USTopic(id: "", title: "")])
    
    func requestTopic() {
        UnsplashService.shared.requestTopics { [weak self] topics in
            guard let self = self else { return }
            self.topicDataStore.value = topics
        } onFailure: { usError in
            print(usError.errors.first!)
        }
    }
}
