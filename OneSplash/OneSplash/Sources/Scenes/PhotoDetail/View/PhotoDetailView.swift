import UIKit
import SnapKit




class PhotoDetailView: BaseView {
    
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = .brown
        return view
    }()
    
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
    }
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    var pageIndex: Int?

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
