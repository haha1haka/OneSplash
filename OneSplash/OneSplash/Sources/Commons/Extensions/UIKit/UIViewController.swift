import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case push
        case present
        case presentNavigation
        case presentFullNavigation
        
    }
    
    func transition<T: UIViewController>(_ viewController: T,
                                         transitionStyle: TransitionStyle = .present)
    {
        switch transitionStyle {
            
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .present:
            self.present(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        }
    }
    
    func showAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            print("completion")
            self.dismiss(animated: true, completion: completion)
        }
    }   
}
