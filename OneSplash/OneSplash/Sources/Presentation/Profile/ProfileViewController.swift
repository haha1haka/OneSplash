import UIKit

class ProfileViewController: BaseViewController {
    
    
    
    let selfView = ProfileView()
    override func loadView() {
        view  = selfView
    }
    
    override func configureInit() {
        print("ProfileViewController")
    }
    
    
    
}
