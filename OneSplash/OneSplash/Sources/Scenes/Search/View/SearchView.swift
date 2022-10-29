import UIKit
import SnapKit

class SearchView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayoutByScopeType())
        view.backgroundColor = .orange
        return view
    }()
    
    var scopeType: ScopeType = .photos
    
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
    //
    func collectionViewLayoutByScopeType() -> UICollectionViewLayout {
        print("👻dfsfs")
        switch scopeType {
        case .photos: return cofigurePhotosLayout()
        case .collections: return cofigurePhotosLayout()
        //case .users: return configureUsersLayout()
        }
    }
    
    
    func cofigurePhotosLayout() -> UICollectionViewLayout {
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
    
    func configureCollectionsLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider:
                { sectionIndex, layoutEnvironment in
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(128))
                    
                    
                    
                    let leftItem  = NSCollectionLayoutItem(layoutSize: itemSize)
                    leftItem.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0)
                    
                    
                    let rightItem  = NSCollectionLayoutItem(layoutSize: itemSize)
                    rightItem.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0)
                    
                    
                    let groupSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .estimated(128))
                    
                    
                    let leftgGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize1, subitems: [leftItem])
                    leftgGroup.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5.0, bottom: 20, trailing: 5.0)
                    
                    let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize1, subitems: [rightItem])
                    
                    
                    
                    
                    let totalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128)), subitems: [leftgGroup, rightGroup])
                    
                    
                    
                    let section = NSCollectionLayoutSection(group: totalGroup)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
                    return section
                })
        
        return collectionViewLayout
        
    }
    
    
    
    func configureUsersLayout() -> UICollectionViewLayout {
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
