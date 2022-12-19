import UIKit
import SnapKit

class ImageView: UIImageView {
    
    var label: UILabel = {
        let view = UILabel()
        return view
        
    }()
    
    convenience init(frame: CGRect = .zero, labelText: String = "") {
        self.init(frame: frame)
        configureLayout()
        configureHierarchy()
        configureAttributes(labelText)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configureHierarchy() {
        self.addSubview(label)
    }
    
    func configureLayout() {
        label.snp.makeConstraints {
            $0.leading.equalTo(self).offset(10)
            $0.bottom.equalTo(self).offset(10)
        }
    }
    
    func configureAttributes(_ labelText: String) {
        label.text = labelText
    }
}
