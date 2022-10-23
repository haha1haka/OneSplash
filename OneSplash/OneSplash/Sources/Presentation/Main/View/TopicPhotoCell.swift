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
        self.addSubview(imageView)
        imageView.addSubview(label)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.leading)
            $0.bottom.equalTo(imageView.snp.bottom)
        }

        self.layer.cornerRadius = 8
    }
    
    func configureAttributes(with item: USTopicPhoto) {
        label.text = item.user.name
        let imageUrl = URL(string: item.urls.thumb)
        imageView.kf.setImage(with: imageUrl)
        
        
    }
    
}
