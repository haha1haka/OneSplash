import Foundation

class PhotoDetailViewModel {
    
    var PhotosDataStore: Observable<[USPhoto]?> = Observable(nil)
    
    let photoRepository = PhotoRepository()
    
    func createPhoto(item: Photo) {
        photoRepository.createPhoto(item: item)
    }
    
}
