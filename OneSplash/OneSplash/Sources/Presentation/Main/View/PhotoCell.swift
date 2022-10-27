import UIKit
import SnapKit
import Kingfisher



class PhotoCell: UICollectionViewCell {
    
//    let contarinerUIView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .lightGray
//        return view
//    }()
    
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .bottom
        return view
    }()
    
    //scaleAspectFill
    //scaleAspectFill
//    /scaleAspectFit
//    /scaleToFill
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        guard let photoItem = photoItem else { return attributes }
        print("🥗\(photoItem)")
        let ratio = CGFloat(photoItem.height) / CGFloat(photoItem.width)
        let newHeight = attributes.bounds.width * ratio
        print("🍙\(newHeight)")
        attributes.bounds.size.height = newHeight
        return attributes
    }

    private var photoItem: USPhoto?
//
    let label: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        view.numberOfLines = .zero
        
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() {
        self.backgroundColor = .systemPink
        //self.addSubview(imageView)
        contentView.addSubview(imageView)
        //contarinerUIView.addSubview(imageView)
        imageView.addSubview(label)
    }
    func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
//        imageView.snp.makeConstraints {
//
//            $0.edges.equalTo(contarinerUIView)
//        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.leading).offset(10)
            $0.bottom.equalTo(imageView.snp.bottom).inset(10)
        }

        self.layer.cornerRadius = 8
    }
    
    func configureAttributes(with item: USPhoto) {
        label.text = item.user.name
        let imageUrl = URL(string: item.urls.regular)
        imageView.kf.setImage(with: imageUrl)
        
        
    }
    
}
