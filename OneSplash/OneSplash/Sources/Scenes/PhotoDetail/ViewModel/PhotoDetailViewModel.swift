import Foundation

class PhotoDetailViewModel {
    
    var PhotosDataStore: Observable<[USPhoto]?> = Observable(nil)
    
    let photoRepository = PhotoRepository()
    
    func createPhoto(item: USPhoto) {
        print("🟩\(String(describing: photoRepository.database.configuration.fileURL))")
        photoRepository.createPhoto(item: item)
    }
    
}
