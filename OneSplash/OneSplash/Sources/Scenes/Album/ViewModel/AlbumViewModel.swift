import Foundation

class AlbumViewModel {
    let photoRepository = PhotoRepository()
    var photoList: Observable<[Photo]> = Observable([])
    
    func fetchPhoto() {
        self.photoList.value = photoRepository.fetchPhoto().map{$0}
    }
    
}
