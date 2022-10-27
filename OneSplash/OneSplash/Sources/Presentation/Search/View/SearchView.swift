import UIKit
import SnapKit

class SearchView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = .orange
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

extension SearchView {
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider:
                { sectionIndex, layoutEnvironment in
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(128))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    return section
                })
        
        return collectionViewLayout
    }

}
