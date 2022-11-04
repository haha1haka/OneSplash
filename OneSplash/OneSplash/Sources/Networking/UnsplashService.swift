import Foundation

class UnsplashService {
    
    private init() { }
    
    static let shared = UnsplashService()
    
    
    func request<T: Decodable>(type: T.Type = T.self, path:String, queryItems: [URLQueryItem], httpMethod: HTTPMethod, headers: [String: String], completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        var urlComponents = URLComponents(string: UnsplashRouter.baseURL)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue.uppercased()
        
        urlRequest.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("📭 Request \(urlRequest.url!)")
            print("🚩 Response \(httpResponse.statusCode)")
            
            if let data = data {
                
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    do {
                        let value = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion((.success(value)))
                        }
                    } catch let decodingError {
                        print("⁉️ Failure", decodingError)
                        DispatchQueue.main.async {
                            completion((.failure(.decodingError)))
                        }
                    }
                } else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                }
            }
            
            if let error = error {
                print("❌ Failure (Internal)", error.localizedDescription)
                DispatchQueue.main.async {
                    completion((.failure(.serverError)))
                }
                return
            }
            
        }.resume()
    }
