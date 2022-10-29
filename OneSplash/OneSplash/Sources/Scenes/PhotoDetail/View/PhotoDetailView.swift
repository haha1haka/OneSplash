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
            let index = Int(contentOffset.x / environment.container.contentSize.width)
            let photo = self.photoStore[index]
            
            if let visibleIndexPath = visibleItems.last?.indexPath {
                self.delegate?.photoDetailView(self, didDisplayAt: visibleIndexPath)

                let itemCount = self.collectionView.numberOfItems(inSection: visibleIndexPath.section)
                let lastIndexPath = IndexPath(item: itemCount - 1, section: visibleIndexPath.section)

                if visibleIndexPath == lastIndexPath {
                    self.delegate?.photoDetailView(self, didDisplay: visibleIndexPath)
                }
            }
            
            self.navigationItem.title = photo.user.name
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
}
