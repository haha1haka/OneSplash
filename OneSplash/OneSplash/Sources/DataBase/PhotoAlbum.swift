import Foundation
import RealmSwift

class PhotoAlbum: Object {
    
    @Persisted var AlbumName: String
    @Persisted var photoDetail: List<Photo>
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(AlbumName: String) {
        self.init()
        self.AlbumName = AlbumName
    }

}
