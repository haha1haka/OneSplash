import Foundation
import RxSwift
import RxCocoa

final class PhotoDetailViewModel {
    
    var mainPhotosDataStore = BehaviorSubject<[USPhoto]>(value: [])
    
    var searchPhotosDataSource: Observable<[USPhoto]?> = Observable(nil)
    var albumPhotosDataStore: Observable<[USPhoto]?> = Observable(nil)
    
    var currentIndex = BehaviorSubject<Int>(value: 0)
    
    let photoRepository = PhotoRepository()
    
    func createPhoto(item: USPhoto) {
        print("🟩\(String(describing: photoRepository.database.configuration.fileURL))")
        photoRepository.createPhoto(item: item)
    }
    
}
