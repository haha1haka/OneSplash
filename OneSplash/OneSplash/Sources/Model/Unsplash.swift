import Foundation

struct USTopic: Decodable, Identifiable, Hashable {
    var id: String
    var title: String
}


struct USPhoto: Decodable, Hashable {
    let id: String
    let width: Int
    let height: Int
    let user: USUser
    let urls: USUrls
}

struct USSearch: Decodable {
    let total: Int
    let totalPages: Int
    let results: [USPhoto]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct USUser: Decodable, Hashable {
    var id: String
    var name: String
}

struct USUrls: Decodable, Hashable {
    var regular: String
}



struct USError: Error, Decodable {
    var errors: [String]
    
    static var decodingError: USError {
        return USError(errors: ["Deconding Error"])
    }
}









