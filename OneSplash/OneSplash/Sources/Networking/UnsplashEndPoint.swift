import Foundation

enum UnsplashEndPoint {
    case topics
    case topicPhotos(id: String)
    case search
    case collections
    
    static let baseURL = "https://api.unsplash.com/"
}

extension UnsplashEndPoint {
    var path: String {
        switch self {
        case .topics: return "/topics"
        case .topicPhotos(let id): return "/topics/\(id)/photos"
        case .search: return "/search/photos"
        case .collections: return "/collections"
        }
    }
}

// topic
// "https://api.unsplash.com/search/photos?page=\(page)&query=\(query)

// topic photo
// https://api.unsplash.com/topics/:id_or_slug/photos?page=530

// https://api.unsplash.com/topics/qPYsDzvJOYc/photos?page=1

//search
// https://api.unsplash.com/search/photos?page=1&query=office

//search collections
// https://api.unsplash.com/search/collections?page=1&query=office
