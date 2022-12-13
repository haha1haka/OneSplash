import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureInit()
    }
    
    func configureInit() { }
    
    func setNavigationBar(title: String = "") {
        navigationItem.title = title
    }
    
    
}
