import Foundation

enum UnsplashEndPoint {
    case topics
    case topicPhotos(id: String)
    case search(page: Int, query: String)
    
    static let baseURL = "https://api.unsplash.com/"
}

extension UnsplashEndPoint {
    var path: String {
        switch self {
        case .topics: return "/topics"
        case .topicPhotos(let id): return "/topics/\(id)/photos?page=1"
        case .search(let page,let query): return "search/photos?page=\(page)&query=\(query)"
        }
    }
}

// topic
// "https://api.unsplash.com/search/photos?page=\(page)&query=\(query)"

// topic photo
// "https://api.unsplash.com/topics/:id_or_slug/photos?page=530"



