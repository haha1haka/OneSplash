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

struct USSearch: Decodable, Hashable {
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


struct Collections: Decodable {
    let total, totalPages: Int
    let results: [USCollection]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}


struct USCollection: Decodable, Hashable {
    let title: String
    let totalPhotos: Int //⭐️
    let user: USUser // 여기 안에 name 만
    let previewPhotos: [PreviewPhoto]

    enum CodingKeys: String, CodingKey {
        case user
        case title
        case totalPhotos = "total_photos"
        case previewPhotos = "preview_photos"
    }
}


struct PreviewPhoto: Decodable, Hashable {
    let urls: USUrls
}
