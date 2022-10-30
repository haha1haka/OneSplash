import Foundation
import RealmSwift

class Photo: Object {
    
    @Persisted var id: String
    @Persisted var urls: String
    @Persisted var like: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(id: String, url: String, like: Bool) {
        self.init()
        self.id = id
        self.urls = urls
        self.like = like
    }
}


