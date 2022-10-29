import UIKit
import SnapKit

class AlbumView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = .purple
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
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        //listConfiguration.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
