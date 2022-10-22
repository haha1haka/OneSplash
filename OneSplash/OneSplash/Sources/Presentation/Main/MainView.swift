import UIKit
import SnapKit

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
                    
                    let columns = Section(rawValue: sectionIndex)?.columnCount
                                    
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalWidth(0.4))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns!)
                    
                    let section = NSCollectionLayoutSection(group: group)

                    section.boundarySupplementaryItems = self.headerItemLayout()
                    
                    return section
                },
            configuration: configuration)
        
        return collectionViewLayout
    }
    
    func headerItemLayout() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
         return [header]
    }
}
