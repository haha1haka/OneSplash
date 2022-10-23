import UIKit
import SnapKit

enum SectionType: Int {
    case topic
    case photo
}
    

class MainView: BaseView {
    
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
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
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        

        
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
    
    
    
    func topicSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                               heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 5, bottom: 50, trailing: 5)
        
        section.boundarySupplementaryItems = self.headerItemLayout()
        
        return section
    }
    
    
    func photoSection() -> NSCollectionLayoutSection {
        var leftItems = [NSCollectionLayoutItem]()
        
        for _ in 1...50 {
            let leftItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(CGFloat.random(in: 1.0...1.4))
            )
            let leftItem = NSCollectionLayoutItem(layoutSize: leftItemSize)
            leftItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 2.5, bottom: 0, trailing: 2.5)
            leftItems.append(leftItem)
            
        }
        var rightItems = [NSCollectionLayoutItem]()
        
        for _ in 1...50 {
            let rightItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(CGFloat.random(in: 1.0...1.4))
            )
            let rightItem = NSCollectionLayoutItem(layoutSize: rightItemSize)
            rightItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 2.5, bottom: 0, trailing: 2.5)
            rightItems.append(rightItem)
            
        }
        

        
        
        
        let leftGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(128))
        let leftgGroup = NSCollectionLayoutGroup.vertical(layoutSize: leftGroupSize, subitems: leftItems)
        leftgGroup.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        
        
        
        let rightGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize: leftGroupSize, subitems: rightItems)
        
        let totalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128)), subitems: [leftgGroup, rightGroup])
        
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
