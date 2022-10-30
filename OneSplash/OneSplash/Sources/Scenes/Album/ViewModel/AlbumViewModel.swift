import Foundation

class AlbumViewModel {
    let photoRepository = PhotoRepository()
    var albumPhotoDataStore: Observable<[USPhoto]> = Observable([])
    
    
    func fetchPhoto() {
        self.albumPhotoDataStore.value = photoRepository.fetchPhoto().map{$0}
    }
    
}
