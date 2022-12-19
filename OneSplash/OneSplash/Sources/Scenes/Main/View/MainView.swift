import UIKit
import SnapKit

class MainView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = .white
        return view
    }()
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        let collectionViewLayout = UICollectionViewCompositionalLayout(
            sectionProvider:
                { sectionIndex, layoutEnvironment in
                    
                    switch sectionIndex {
                    case 0: return self.topicSection()
                    default: return self.photoSection()
                    }
                },
            configuration: configuration)
        
        return collectionViewLayout
    }
    
    
    
    private func topicSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalWidth(0.6))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 5, bottom: 50, trailing: 5)
        
        section.boundarySupplementaryItems = self.headerItemLayout()
        
        return section
    }
    
    


    
    private func photoSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(128))
        
        let leftItem  = NSCollectionLayoutItem(layoutSize: itemSize)
        leftItem.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0)
        
        let rightItem  = NSCollectionLayoutItem(layoutSize: itemSize)
        rightItem.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0)
        
        
        let groupSize1 = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(128))
        
        let leftgGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize1,
            subitems: [leftItem])
        
        leftgGroup.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5.0, bottom: 20, trailing: 5.0)
        
        let rightGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize1,
            subitems: [rightItem])
        
        let totalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(128)), subitems: [leftgGroup, rightGroup])
        
        let section = NSCollectionLayoutSection(group: totalGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        return section
    }

    func headerItemLayout() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
         return [header]
    }
}

