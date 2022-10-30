import Foundation

class AlbumViewModel {
    let photoRepository = PhotoRepository()
    var photoList: Observable<[Photo]> = Observable([])
    
    

}
