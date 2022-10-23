import Foundation




struct USTopic: Decodable, Identifiable, Hashable {
    var id: String
    var title: String
}


struct USError: Error, Decodable {
    var errors: [String]
    
    static var decodingError: USError {
        return USError(errors: ["Deconding Error"])
    }
}


struct USTopicPhoto: Decodable, Hashable {
    let id: String
    let width: Int
    let height: Int
    let user: USUser
    let urls: USUrls
}

struct USUser: Decodable, Hashable {
    var id: String
    var name: String
}

struct USUrls: Decodable, Hashable {
    var thumb: String
}



