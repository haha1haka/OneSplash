import Foundation

struct UnSplash {
    let imageURL: String
}

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

