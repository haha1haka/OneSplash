import UIKit

class TabBarController: UITabBarController {
    
    
    let mainViewController = UINavigationController(rootViewController: MainViewController())
    let searchViewController = UINavigationController(rootViewController: SearchViewContoller())
    let profileViewController = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
        mainViewController.tabBarItem.image = UIImage(systemName: "photo")
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        profileViewController.tabBarItem.image = UIImage(systemName: "person.crop.circle.fill")
        viewControllers = [mainViewController, searchViewController, profileViewController]
    }
    
    
    
}
