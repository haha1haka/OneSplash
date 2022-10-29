import UIKit
import SnapKit




class PhotoDetailView: BaseView {
    
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = .brown
        return view
    }()
    var floatingButton = UIButton(type: .custom)
    
    var pageIndex: Int?
    
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
        self.addSubview(floatingButton)
    }
    
    
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    
    override func configureAttributes() {
        floatingButton.tintColor = .white
        floatingButton.layer.cornerRadius = 30
        floatingButton.backgroundColor = .black
        floatingButton.layer.masksToBounds = true
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setTitleColor(UIColor.orange, for: .normal)
        floatingButton.setImage(UIImage(systemName: "tray.and.arrow.down"), for: .normal)
        //roundButton.layer.frame.size.width/2 ⭐️ 왜 with 못불러 오는지 확인 하기
    }
    

}






extension PhotoDetailView {
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let sctionSize = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: sctionSize)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, contentOffset, environment in
            guard let self = self else { return }
            // ⭐️contentOffset 확실히 알아보기
            self.pageIndex = Int(contentOffset.x / environment.container.contentSize.width)
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
    

}
