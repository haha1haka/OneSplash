import Foundation

class UnsplashService {
    
    private init() { }
    
    static let shared = UnsplashService()
    
    static let headers: [String: String] = [
        "Accept-Version": "v1",
        "Authorization": "Client-ID \(UnsplashAPIKey.appKey)"
    ]
    
    func requestTopics(onSuccess: @escaping (([USTopic]) -> Void),onFailure: @escaping ((USError) -> Void)) {
        var urlComponents = URLComponents(string: UnsplashEndPoint.baseURL)
        urlComponents?.path = UnsplashEndPoint.topics.path
        urlComponents?.queryItems = [
            URLQueryItem(name: "order_by", value: "featured")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        //print(url)
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethod.get.rawValue.uppercased()
        
        urlRequest.allHTTPHeaderFields = UnsplashService.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("📭 Request \(urlRequest.url!)")
            print("🚩 Response \(httpResponse.statusCode)")
            
            if let data = data {
                
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    do {
                        let topics = try JSONDecoder().decode([USTopic].self, from: data)
                        DispatchQueue.main.async {
                            onSuccess(topics)
                        }
                    }
                    catch let decodingError {
                        print("⁉️ Failure", decodingError)
                        DispatchQueue.main.async {
                            onFailure(.decodingError)
                        }
                    }
                }
                else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                }
                
            }
            
            if let error = error {
                print("❌ Failure (Internal)", error.localizedDescription)
                DispatchQueue.main.async {
                    onFailure(USError(errors: [error.localizedDescription]))
                }
                return
            }
            
        }.resume()
        
    }
    
    
    func requestTopicPhotos(from topic: USTopic, onSuccess: @escaping (([USPhoto]) -> Void)) {
        
        var urlComponents = URLComponents(string: UnsplashEndPoint.baseURL)
        urlComponents?.path = UnsplashEndPoint.topicPhotos(id: topic.id).path
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "1")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethod.get.rawValue.uppercased()
        
        urlRequest.allHTTPHeaderFields = UnsplashService.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            print("🙈 Request \(urlRequest.url!)")
            print("🙉 Response \(httpResponse.statusCode)")
            
            if let data = data {
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    
                    do {
                        let topicPhotos = try JSONDecoder().decode([USPhoto].self, from: data)
                        
                        DispatchQueue.main.async {
                            onSuccess(topicPhotos)
                        }
                        
                        
                    } catch let decodingError {
                        print("⁉️ Failure", decodingError)
                    }
                    
                } else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                }
                
                if let error = error {
                    print("❌ Failure (Internal)", error.localizedDescription)
                    return
                }
                
            }
            
        }.resume()
    }
    
    func requestSearchPhotos(query: String, onSuccess: @escaping ((USSearch) -> Void)) {
        
        var urlComponents = URLComponents(string: UnsplashEndPoint.baseURL)
        urlComponents?.path = UnsplashEndPoint.search.path
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "query", value: "\(query)")
        ]
        
        guard let url = urlComponents?.url else { return }
        print("⚙️\(url)")
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethod.get.rawValue.uppercased()
        
        urlRequest.allHTTPHeaderFields = UnsplashService.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            print("🙈 Request \(urlRequest.url!)")
            print("🙉 Response \(httpResponse.statusCode)")
            
            if let data = data {
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    
                    do {
                        let searchPhotos = try JSONDecoder().decode(USSearch.self, from: data)
                        
                        DispatchQueue.main.async {
                            onSuccess(searchPhotos)
                        }
                        
                        
                    } catch let decodingError {
                        print("⁉️💰 Failure", decodingError)
                    }
                    
                } else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                }
                
                if let error = error {
                    print("❌ Failure (Internal)", error.localizedDescription)
                    return
                }
                
            }
            
        }.resume()
    }

    
    func requestSearchCollections(onSuccess: @escaping ((USCollection) -> Void)) {
        
        var urlComponents = URLComponents(string: UnsplashEndPoint.baseURL)
        urlComponents?.path = UnsplashEndPoint.collections.path
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "1")
        ]
        
        guard let url = urlComponents?.url else { return }
        print("⚙️\(url)")
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethod.get.rawValue.uppercased()
        
        urlRequest.allHTTPHeaderFields = UnsplashService.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            print("🙈 Request \(urlRequest.url!)")
            print("🙉 Response \(httpResponse.statusCode)")
            
            if let data = data {
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    print("👺\(data)")
                    do {
                        let collection = try JSONDecoder().decode(USCollection.self, from: data)
                        print(collection)
                        DispatchQueue.main.async {
                            onSuccess(collection)
                        }
                        
                        
                    } catch let decodingError {
                        print("⁉️💰 Failure", decodingError)
                    }
                    
                } else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                }
                
                if let error = error {
                    print("❌ Failure (Internal)", error.localizedDescription)
                    return
                }
                
            }
            
        }.resume()
    }
    
    
    
  
}

