import Foundation
import RealmSwift

//⭐️ 알고 쓰기
protocol PhotoDataBaseRepository {
    func createPhoto(item: Photo)
    func fetchPhoto() -> Results<Photo>
}

class PhotoRepository: PhotoDataBaseRepository {
    
    let database = try! Realm()
    
    
    func createPhoto(item: Photo) {
        do {
            try database.write {
                database.add(item)
            }
        } catch let error {
            print("Create error: \(error)")
        }
    }
    
    func fetchPhoto() -> Results<Photo> {
        return database.objects(Photo.self)
    }

}
