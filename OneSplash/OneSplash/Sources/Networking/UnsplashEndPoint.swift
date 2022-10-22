import Foundation

enum UnsplashEndPoint {
    case topics
    case search(page: Int, query: String)
    
    static let baseURL = "https://api.unsplash.com/"
}

extension UnsplashEndPoint {
    var path: String {
        switch self {
        case .topics: return "/topics"
        case .search(let page,let query): return "search/photos?page=\(page)&query=\(query)"
        }
    }
}
// "https://api.unsplash.com/search/photos?page=\(page)&query=\(query)"




//enum UnsplashAPI {
//  case topics
//  case photos(id: String, page: Int)
//  case search(query: String, page: Int)
//}
//
//extension UnsplashAPI {
//
//}
//
//enum UnsplashURL: String {
//    case topics
//    case search
//}
