import UIKit
import SnapKit

final class SearchResultHeaderView: UICollectionReusableView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    var clearButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .lightGray
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        view.setTitle("clear", for: .normal)
        return view
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
        addSubview(clearButton)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self).inset(15)
            $0.top.equalTo(self).offset(10)
            $0.bottom.equalTo(self).inset(10)
            $0.trailing.equalTo(clearButton.snp.leading).offset(8)
        }
        
        clearButton.snp.makeConstraints {
            $0.top.equalTo(self).offset(15)
            $0.trailing.equalTo(self).inset(15)
            $0.bottom.equalTo(self).inset(15)
            $0.width.equalTo(44)
        }
    }
    
    
    func configureAttributes(with title: String) {
        titleLabel.text = title
    }
}


