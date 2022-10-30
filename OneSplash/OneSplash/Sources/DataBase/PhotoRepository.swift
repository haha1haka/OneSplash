import Foundation
import RealmSwift

//⭐️ 알고 쓰기
protocol PhotoDataBaseRepository {
    func createPhoto(item: USPhoto)
    func fetchPhoto() -> Results<USPhoto>
}

class PhotoRepository: PhotoDataBaseRepository {
    
    let database = try! Realm()
    
    
    func createPhoto(item: USPhoto) {
        do {
            try database.write {
                database.add(item)
            }
        } catch let error {
            print("Create error: \(error)")
        }
    }
    
    func deletePhoto(item: USPhoto) {
        do {
            try database.write {
                database.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    
    
    
    
    func fetchPhoto() -> Results<USPhoto> {
        return database.objects(USPhoto.self)
    }

}
