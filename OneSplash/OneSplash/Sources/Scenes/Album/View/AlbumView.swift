import UIKit
import SnapKit

final class AlbumView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureCollectionViewLayout()
        )
        view.backgroundColor = .white
        return view
    }()

    override func configureHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
}
extension AlbumView {
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
