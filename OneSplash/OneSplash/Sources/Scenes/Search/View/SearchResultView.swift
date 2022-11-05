import UIKit
import SnapKit

final class SearchResultView: BaseView {
    
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
            $0.edges.equalTo(self)
        }
    }
    
}

extension SearchResultView {
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        listConfiguration.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
}
