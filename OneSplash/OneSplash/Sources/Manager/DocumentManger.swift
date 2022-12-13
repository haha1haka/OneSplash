import UIKit

enum IsFileExist {
    case yes
    case no
}

final class DocumentManager {
    
    static let shared = DocumentManager()
    
    private init() { }
    
    private func documentDirectoryPath() -> URL? {
        guard let documentDiretory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentDiretory
    }
    
    private func unsplashImageStoreDirectoryPath() -> URL? {
        let imageDirectory = documentDirectoryPath()?.appendingPathComponent("UnsplashImageStore")
        return imageDirectory
    }
    
    func saveImageToDocument(fileName: String, image: UIImage, completion: @escaping () -> Void) {
        
        guard let unsplashImageDirectory = unsplashImageStoreDirectoryPath() else { return }
        
        let isFileExist = FileManager.default.fileExists(atPath: unsplashImageDirectory.path) == true ? IsFileExist.yes : IsFileExist.no
        
        switch isFileExist {
        case .yes:
            pushImage(to: unsplashImageDirectory, leadingPath: fileName, image: image)
            
            completion()
        case .no:
            do {
                try FileManager.default.createDirectory(at: unsplashImageDirectory, withIntermediateDirectories: true)
            } catch {
                print("경로 문제")
            }
            pushImage(to: unsplashImageDirectory, leadingPath: fileName, image: image)
            completion()
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let imageDirectory = unsplashImageStoreDirectoryPath() else {return nil}
        let fileURL = imageDirectory.appendingPathComponent(fileName)
        let isFileExist = FileManager.default.fileExists(atPath: fileURL.path) == true ? IsFileExist.yes : IsFileExist.no
        
        switch isFileExist {
        case .yes:
            return UIImage(contentsOfFile: fileURL.path)
        case .no:
            return UIImage(systemName: "person.fill")
        }
    }
    
    private func pushImage(to unsplashImageDirectory : URL,leadingPath fileName: String, image: UIImage) {
        let fileURL = unsplashImageDirectory.appendingPathComponent(fileName)
        print("🙀File Location: \(fileURL)")
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("File save Error: \(error)")
        }
    }
}

//⭐️ 잭
//    var documentDirectoryPath2: URL? {
//        guard let documentDiretory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
//        return documentDiretory
//    }
