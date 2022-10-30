import Foundation

class PhotoDetailViewModel {
    
    var mainPhotosDataStore: Observable<[USPhoto]?> = Observable(nil)
    var searchPhotosDataSource: Observable<[USPhoto]?> = Observable(nil)
    var albumPhotosDataStore: Observable<[USPhoto]?> = Observable(nil)
    
    let photoRepository = PhotoRepository()
    
    func createPhoto(item: USPhoto) {
        print("🟩\(String(describing: photoRepository.database.configuration.fileURL))")
        photoRepository.createPhoto(item: item)
    }
    
}
