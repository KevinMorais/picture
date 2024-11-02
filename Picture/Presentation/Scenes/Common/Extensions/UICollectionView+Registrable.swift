//
//  UICollectionView+Registrable.swift
//  Picture
//
//  Created by Kevin Morais on 01/11/2024.
//

import UIKit

extension UICollectionView {

    func register(_ reusableCell: UICollectionViewCell.Type) {
        self.register(reusableCell, forCellWithReuseIdentifier: reusableCell.ReuseIdentifier)
    }

    func register(_ reusableCell: UICollectionReusableView.Type, forSupplementaryViewOfKind: String) {
        self.register(reusableCell, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: reusableCell.ReuseIdentifier)
    }

    func dequeue<T: Reusable>(_ reusableCell: T.Type, for indexPath: IndexPath) -> T? {
        self.dequeueReusableCell(withReuseIdentifier: reusableCell.ReuseIdentifier, for: indexPath) as? T
    }

    func dequeueReusableSupplementaryView<T: Reusable>(ofKind: String, _ reusableCell: T.Type, for indexPath: IndexPath) -> T? {
        return self.dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: reusableCell.ReuseIdentifier, for: indexPath) as? T
    }

}
