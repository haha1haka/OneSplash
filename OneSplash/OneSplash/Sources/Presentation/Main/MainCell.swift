import UIKit
import SnapKit

class MainCell: BaseCollectionViewCell {
    
    let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return view
    }()
    

    override func configureHierarchy() {
        self.backgroundColor = .systemPink
        self.addSubview(label)
    }
    override func configureLayout() {
        label.snp.makeConstraints {
            $0.center.equalTo(self)
        }
    }
    func configureAttributes(with title: String) {
        label.text = title
    }
    
}
