import Foundation
import RealmSwift

class SearchLog: Object {
    
    @Persisted var text : String

    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}


