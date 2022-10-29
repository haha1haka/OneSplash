import UIKit
import SnapKit
import Kingfisher

class CollectionCell: BaseCollectionViewCell {
    
    let imageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 1
        return view
    }()
    
//    let leftImageView = ImageView()
//    let centerImageView = ImageView()
//    let rightImageView = ImageView()
    
    
    let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 2
        return view
    }()
    
    let mainLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    let secondaryLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .light)
        view.textColor = .lightGray
        return view
    }()

    override func configureHierarchy() {
        self.addSubview(imageStackView)
        //[leftImageView, centerImageView, rightImageView].forEach { imageStackView.addArrangedSubview($0) }
        self.addSubview(labelStackView)
        [mainLabel, secondaryLabel].forEach{ labelStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        imageStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(imageStackView)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(self)
        }
    }
    
    override func configureAttributesInit() {
        self.layer.cornerRadius = 8
    }
    
    //⭐️thumb 으로 바꾸기 or small?
    func configureAttributes(with item: USCollection) {
        let previewPhotos = item.previewPhotos
        //leftImageView.kf.setImage(with: URL(string: previewPhotos[0].urls.regular))
        //centerImageView.kf.setImage(with: URL(string: previewPhotos[1].urls.regular))
        //rightImageView.kf.setImage(with: URL(string: previewPhotos[2].urls.regular))
                
        
        
        
    }
    
}

