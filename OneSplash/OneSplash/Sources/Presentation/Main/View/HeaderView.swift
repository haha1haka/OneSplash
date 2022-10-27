import UIKit
import SnapKit

class HeaderView: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self).inset(15)
            $0.top.equalTo(self).offset(10)
            $0.bottom.equalTo(self).offset(10)
        }
    }
    
    
    func configureAttributes(with title: String) {
        titleLabel.text = title
    }
}


