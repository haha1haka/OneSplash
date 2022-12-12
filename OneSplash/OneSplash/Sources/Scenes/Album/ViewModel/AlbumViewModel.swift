import Foundation
import RxSwift
import RxCocoa

final class AlbumViewModel {
    let photoRepository = PhotoRepository()
    var albumPhotoDataStore = BehaviorSubject<[USPhoto]>(value: [USPhoto(id: "", width: 0, height: 0, user: USUser(id: "", name: ""), urls: USUrls(regular: ""))])
    
    
    func fetchPhoto() {
        self.albumPhotoDataStore
            .onNext(photoRepository.fetchPhoto().map{$0})
    }
}
