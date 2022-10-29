import UIKit

class TabBarController: UITabBarController {
    
    
    let mainViewController = UINavigationController(rootViewController: MainViewController())
    let searchViewController = UINavigationController(rootViewController: SearchViewContoller())
    let albumViewController = UINavigationController(rootViewController: AlbumViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        mainViewController.tabBarItem.image = UIImage(systemName: "photo")
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        albumViewController.tabBarItem.image = UIImage(systemName: "person.crop.circle.fill")
        viewControllers = [mainViewController, searchViewController, albumViewController]
    }
    
    
    
}
