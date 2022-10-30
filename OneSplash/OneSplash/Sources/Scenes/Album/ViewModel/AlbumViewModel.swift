import Foundation

class AlbumViewModel {
    let photoRepository = PhotoRepository()
    var photoList: Observable<[USPhoto]> = Observable([])
    
    func fetchPhoto() {
        self.photoList.value = photoRepository.fetchPhoto().map{$0}
    }
    
}
