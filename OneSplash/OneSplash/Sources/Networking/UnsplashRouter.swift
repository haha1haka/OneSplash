import Foundation

enum UnsplashRouter {
    case topics
    case topicPhotos(id: String)
    case search(query: String)
    
    static let baseURL = "https://api.unsplash.com/"
    
}

extension UnsplashRouter {
    var path: String {
        switch self {
        case .topics: return "/topics"
        case .topicPhotos(let id): return "/topics/\(id)/photos"
        case .search: return "/search/photos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .topics:
            return [URLQueryItem(name: "order_by", value: "featured")]
        case .topicPhotos:
            return [URLQueryItem(name: "page", value: "1")]
        case .search(let query):
            return [URLQueryItem(name: "page", value: "1"),
                    URLQueryItem(name: "query", value: "\(query)")]
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }

    }
    
    var headers: [String: String] {
        switch self {
        default:
            return ["Accept-Version": "v1",
                    "Authorization": "Client-ID \(UnsplashAPIKey.appKey)"]
        }
    }
    
    
    
}
