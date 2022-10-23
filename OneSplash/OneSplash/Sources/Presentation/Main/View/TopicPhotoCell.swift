import UIKit
import SnapKit
import Kingfisher



class TopicPhotoCell: BaseCollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    
    let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        view.numberOfLines = .zero
        
        return view
    }()
    

    override func configureHierarchy() {
        self.backgroundColor = .systemPink
        self.addSubview(label)
        
    }
    override func configureLayout() {
        label.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        self.layer.cornerRadius = 8
    }
    
    func configureAttributes(with title: String) {
        label.text = title
    }
    
}
