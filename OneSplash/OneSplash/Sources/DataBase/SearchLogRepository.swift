import Foundation
import RealmSwift


protocol SearchLogRepositoryType {
    func addLog(item: SearchLog)
    func deleteLog(item: SearchLog)
    func fetchLog() -> Results<SearchLog>
    func deleteAllLog()
}

final class SearchLogRepository: SearchLogRepositoryType {
    
    let database = try! Realm()
    
    func addLog(item: SearchLog) {
        do {
            try database.write {
                database.add(item)
            }
        } catch let error {
            print("Create error: \(error)")
        }
    }
    
    func deleteLog(item: SearchLog) {
        do {
            try database.write {
                database.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteAllLog() {
        do {
            try database.write {
                database.deleteAll()
            }
            
        } catch let error {
            print(error)
        }
    }

    func fetchLog() -> Results<SearchLog> {
        return database.objects(SearchLog.self)
    }

}
